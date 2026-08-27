package com.LeaseManager.Dto.User;

import com.LeaseManager.Entity.UserRole;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Запрос на создание пользователя
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateUserRequest {

    @NotBlank(message = "Имя пользователя не может быть пустым")
    @Size(min = 3, max = 50, message = "Имя пользователя должно быть от 3 до 50 символов")
    private String username;

    @NotBlank(message = "Пароль не может быть пустым")
    @Size(min = 6, max = 100, message = "Пароль должен быть от 6 до 100 символов")
    private String password;

    @NotNull(message = "Роль обязательна")
    private UserRole role;

    @NotBlank(message = "ФИО не может быть пустым")
    @Size(max = 200, message = "ФИО должно быть не более 200 символов")
    private String fullName;

    @NotBlank(message = "Email не может быть пустым")
    @Size(max = 100, message = "Email должен быть не более 100 символов")
    private String email;

    @Builder.Default
    private Boolean active = true;
}
