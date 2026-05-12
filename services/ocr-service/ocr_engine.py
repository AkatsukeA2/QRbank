from fastapi import FastAPI, HTTPException, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from paddleocr import PaddleOCR
import cv2
import numpy as np
import re

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

ocr = PaddleOCR(use_angle_cls=True, lang='en', use_gpu=False, show_log=False)

# ---------- Pré-processamento ----------
def preprocess_image(image_bytes):
    nparr = np.frombuffer(image_bytes, np.uint8)
    img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    if img is None:
        raise ValueError("Imagem não pôde ser descodificada")
    lab = cv2.cvtColor(img, cv2.COLOR_BGR2LAB)
    l, a, b = cv2.split(lab)
    l = cv2.equalizeHist(l)
    lab = cv2.merge((l, a, b))
    enhanced = cv2.cvtColor(lab, cv2.COLOR_LAB2BGR)
    return enhanced

# ---------- Extração de campos ----------
def parse_bi_text(text):
    data = {}
    name_match  = re.search(r'Nome[:\s]+(.+)',                          text, re.IGNORECASE)
    nif_match   = re.search(r'NIF[:\s]+(\d+)',                          text, re.IGNORECASE)
    dob_match   = re.search(r'Data de Nascimento[:\s]+(\d{2}/\d{2}/\d{4})', text, re.IGNORECASE)
    bi_match    = re.search(r'\d{9}[A-Z]{2}\d{3}',                     text)
    if name_match: data['name']      = name_match.group(1).strip()
    if nif_match:  data['nif']       = nif_match.group(1).strip()
    if dob_match:  data['dob']       = dob_match.group(1).strip()
    if bi_match:   data['bi_number'] = bi_match.group(0).strip()
    return data

# ---------- Endpoint ----------
@app.post("/process")
async def process(file: UploadFile = File(...)):
    image_bytes = await file.read()
    try:
        # ✅ Pré-processar e guardar em ficheiro temporário
        processed = preprocess_image(image_bytes)
        tmp_path = "/tmp/ocr_input.jpg"
        cv2.imwrite(tmp_path, processed)

        # ✅ Passar caminho — única forma fiável com PaddleOCR
        ocr_result = ocr.ocr(tmp_path, cls=True)

        # ✅ Extrair texto com protecção contra None
        lines = []
        if ocr_result:
            for page in ocr_result:
                if not page:
                    continue
                for line in page:
                    if line and len(line) >= 2 and line[1] and line[1][0]:
                        lines.append(line[1][0])

        full_text   = "\n".join(lines)
        parsed_data = parse_bi_text(full_text)

    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"OCR falhou: {e}")

    return {"raw_text": full_text, "parsed": parsed_data}

@app.get("/")
async def hello():
    return {"message": "OCR service para BI português activo!"}