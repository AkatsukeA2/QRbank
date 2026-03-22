package backend_api.Qrbank.model;

import com.fasterxml.jackson.annotation.JsonCreator;

public enum GuardianRelationship {

    FATHER,
    MOTHER,
    UNCLE,
    OLDER_SIBLING;

    @JsonCreator
    public static GuardianRelationship from(String value) {
        return switch (value.toUpperCase()) {
            case "PAI", "FATHER" -> FATHER;
            case "MAE", "MOTHER" -> MOTHER;
            case "TIO", "UNCLE" -> UNCLE;
            case "IRMAO", "OLDER_SIBLING" -> OLDER_SIBLING;
            default -> throw new IllegalArgumentException("Invalid relationship");
        };
    }
}
