package com.LeaseManager.Service.GeneratePassword;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@ExtendWith(MockitoExtension.class)
public class HashPassword {


    @Test
    void generate()
    {
        BCryptPasswordEncoder bCryptPasswordEncoder = new BCryptPasswordEncoder();

        String hash = bCryptPasswordEncoder.encode("admin123");

        System.out.println(hash);

        System.out.println(bCryptPasswordEncoder.matches("admin123", hash));
    }
}
