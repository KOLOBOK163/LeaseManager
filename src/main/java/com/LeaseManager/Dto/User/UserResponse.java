package com.LeaseManager.Dto.User;

import com.LeaseManager.Entity.UserRole;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserResponse {

    private Long id;
    private String username;
    private UserRole role;
    private String fullName;
    private String email;
    private Boolean active;
}
