package helpers;

import java.util.Random;

import com.github.javafaker.Faker;

public class DataGenerator {

    public static Random generatorBoolean = new Random();

    public static String getRandomBooleaString() {
        return String.valueOf(generatorBoolean.nextBoolean());
    }

    public static String getRandomEmail() {
        Faker faker = new Faker();
        String email = faker.internet().emailAddress();
        return email;
    }

    public static String getRandomUsername() {
        Faker faker = new Faker();
        String username = faker.name().username();
        return username;
    }

    public static String getRandomPassword() {
        Faker faker = new Faker();
        String password = faker.internet().password();
        return password;
    }
}
