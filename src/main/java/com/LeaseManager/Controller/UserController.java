package com.LeaseManager.Controller;

import com.LeaseManager.Dto.User.CreateUserRequest;
import com.LeaseManager.Dto.User.UpdateUserRequest;
import com.LeaseManager.Dto.User.UserResponse;
import com.LeaseManager.Service.User.UserService;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/users")
@PreAuthorize("hasRole('ADMIN')")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping
    public ResponseEntity<List<UserResponse>> getAllUsers() {
        return ResponseEntity.ok(userService.getAllUsers());
    }

    @GetMapping("/{id}")
    public ResponseEntity<UserResponse> getUserById(@PathVariable Long id) {
        UserResponse user = userService.getUserById(id);
        return ResponseEntity.ok(user);
    }

    @PostMapping
    public ResponseEntity<?> createUser(@Valid @RequestBody CreateUserRequest request) {
            UserResponse created = userService.createUser(request);
            return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateUser(
            @PathVariable Long id,
            @Valid @RequestBody UpdateUserRequest request) {
            UserResponse updated = userService.updateUser(id, request);
            return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, String>> deleteUser(@PathVariable Long id) {
            userService.deleteUser(id);
            return ResponseEntity.noContent().build();
    }


    @PostMapping("/{id}/change-password")
    public ResponseEntity<Map<String, String>> changeUserPassword(
            @PathVariable Long id,
            @RequestBody Map<String, String> passwordRequest) {
            String newPassword = passwordRequest.get("newPassword");
            if (newPassword == null || newPassword.length() < 6) {
                Map<String, String> error = new HashMap<>();
                error.put("message", "Пароль должен быть не менее 6 символов");
                return ResponseEntity.badRequest().body(error);
            }
            userService.changeUserPassword(id, newPassword);
            Map<String, String> success = new HashMap<>();
            success.put("message", "Пароль успешно изменён");
            return ResponseEntity.ok(success);
    }
}
