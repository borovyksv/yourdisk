package com.relzet.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class QuickPasswordEncodingGenerator {

    /**
     * This class can help you with generating password to manipulate immediately with DB`s user passwords
    */
    public static void main(String[] args) {
        String password = "admin";

        BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
        System.out.println(passwordEncoder.encode(password));
    }

}