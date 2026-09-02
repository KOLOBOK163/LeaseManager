package com.LeaseManager.Dto.User;

import com.LeaseManager.Entity.UserRole;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UpdateUserRequest {

    @Size(min = 3, max = 50, message = "Имя пользователя должно быть от 3 до 50 символов")
    private String username;

    @Size(min = 6, max = 100, message = "Пароль должен быть от 6 до 100 символов")
    private String password;

    private UserRole role;

    @Size(max = 200, message = "ФИО должно быть не более 200 символов")
    private String fullName;

    @Size(max = 100, message = "Email должен быть не более 100 символов")
    private String email;

    private Boolean active;
}
