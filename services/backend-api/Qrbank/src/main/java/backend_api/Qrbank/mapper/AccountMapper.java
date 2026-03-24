package backend_api.Qrbank.mapper;

import backend_api.Qrbank.dto.AccountRequestDTO;
import backend_api.Qrbank.dto.AccountResponseDTO;
import backend_api.Qrbank.model.Account;
import org.jetbrains.annotations.NotNull;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Component
public class AccountMapper {
    private static final String bankCode ="QRB-";

    public static AccountResponseDTO toResponse(Account account){
        return new AccountResponseDTO(
                account.getId(),
                account.getAccountNumber(),
                account.getIban(),
                account.getBalance(),
                account.getCurrency(),
                account.isActive(),
                account.getCreatedAt()

        );
    }

    public static Account toEntity(AccountRequestDTO requestDTO){

        String accountNumber = generateAccountNumber();
        String iban = generateIBAN(accountNumber,requestDTO);
        return new Account(
                null,
                requestDTO.userId(),
                accountNumber,
                iban,
                BigDecimal.ZERO,
                requestDTO.currency(),
                true,
                LocalDateTime.now(),
                null,
                null


        );
    }

    @NotNull
    private static String generateAccountNumber() {
        String random = UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        return bankCode + random;
    }

    @NotNull
    private static String generateIBAN(@NotNull String accountNumber, @NotNull AccountRequestDTO requestDTO) {

        String countryCode = requestDTO.currency().toString();
        String accountPart = accountNumber.replace(bankCode, "");

        String base = bankCode + accountPart + countryCode + "00";

        String numeric = convertToNumeric(base);

        int mod = mod97(numeric);

        int checkDigits = 98 - mod;

        return countryCode + String.format("%02d", checkDigits) + bankCode + accountPart;
    }
    @NotNull
    private static String convertToNumeric(@NotNull String input) {
        StringBuilder result = new StringBuilder();

        for (char ch : input.toCharArray()) {
            if (Character.isLetter(ch)) {
                int value = ch - 'A' + 10;
                result.append(value);
            } else {
                result.append(ch);
            }
        }

        return result.toString();
    }
    private static int mod97(@NotNull String number) {
        int remainder = 0;

        for (int i = 0; i < number.length(); i++) {
            int digit = Character.getNumericValue(number.charAt(i));
            remainder = (remainder * 10 + digit) % 97;
        }

        return remainder;
    }
}
