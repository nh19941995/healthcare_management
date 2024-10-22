package org.example.healthcare_management.enums;

public enum Gender {
    MALE,
    FEMALE;

    public static Gender fromString(String genderString) {
        for (Gender gender : Gender.values()) {
            if (gender.name().equalsIgnoreCase(genderString)) {
                return gender;
            }
        }
        throw new IllegalArgumentException("Invalid gender: " + genderString);
    }
}
