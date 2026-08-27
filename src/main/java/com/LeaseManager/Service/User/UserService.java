package com.LeaseManager.Service.User;

import com.LeaseManager.Dto.User.ChangePasswordRequest;
import com.LeaseManager.Dto.User.CreateUserRequest;
import com.LeaseManager.Dto.User.UpdateUserRequest;
import com.LeaseManager.Dto.User.UserResponse;
import com.LeaseManager.Entity.User;
import com.LeaseManager.Entity.UserRole;
import com.LeaseManager.Repository.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public UserService(UserRepository userRepository,
                       PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional(readOnly = true)
    public List<UserResponse> getAllUsers() {
        return userRepository.findAll().stream()
                .map(this::toResponse)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public UserResponse getUserById(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("Пользователь не найден с id: " + userId));
        return toResponse(user);
    }

    @Transactional(readOnly = true)
    public UserResponse getUserByUsername(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new EntityNotFoundException("Пользователь не найден: " + username));
        return toResponse(user);
    }

    @Transactional
    public UserResponse createUser(CreateUserRequest request) {
        // Проверка на уникальность username
        if (userRepository.existsByUsername(request.getUsername())) {
            throw new IllegalArgumentException("Пользователь с таким именем уже существует");
        }

        User user = User.builder()
                .username(request.getUsername())
                .password(passwordEncoder.encode(request.getPassword()))
                .role(request.getRole())
                .fullName(request.getFullName())
                .email(request.getEmail())
                .active(request.getActive() != null ? request.getActive() : true)
                .build();

        User saved = userRepository.save(user);
        return toResponse(saved);
    }

    @Transactional
    public UserResponse updateUser(Long userId, UpdateUserRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("Пользователь не найден с id: " + userId));

        // Обновление username
        if (request.getUsername() != null && !request.getUsername().isBlank()) {
            if (!request.getUsername().equals(user.getUsername()) &&
                userRepository.existsByUsername(request.getUsername())) {
                throw new IllegalArgumentException("Пользователь с таким именем уже существует");
            }
            user.setUsername(request.getUsername());
        }

        // Обновление пароля
        if (request.getPassword() != null && !request.getPassword().isBlank()) {
            user.setPassword(passwordEncoder.encode(request.getPassword()));
        }

        // Обновление роли
        if (request.getRole() != null) {
            user.setRole(request.getRole());
        }

        // Обновление ФИО
        if (request.getFullName() != null) {
            user.setFullName(request.getFullName());
        }

        // Обновление email
        if (request.getEmail() != null) {
            user.setEmail(request.getEmail());
        }

        // Обновление статуса active
        if (request.getActive() != null) {
            // Запрет на деактивацию последнего ADMIN
            if (!request.getActive() && user.getRole() == UserRole.ADMIN) {
                long adminCount = userRepository.countByRole(UserRole.ADMIN);
                if (adminCount <= 1) {
                    throw new IllegalArgumentException("Нельзя деактивировать последнего администратора");
                }
            }
            user.setActive(request.getActive());
        }

        User updated = userRepository.save(user);
        return toResponse(updated);
    }

    @Transactional
    public void deleteUser(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("Пользователь не найден с id: " + userId));

        // Запрет на удаление последнего ADMIN
        if (user.getRole() == UserRole.ADMIN) {
            long adminCount = userRepository.countByRole(UserRole.ADMIN);
            if (adminCount <= 1) {
                throw new IllegalArgumentException("Нельзя удалить последнего администратора");
            }
        }

        // Запрет на удаление самого себя
        User currentUser = getCurrentUser();
        if (currentUser != null && currentUser.getId().equals(userId)) {
            throw new IllegalArgumentException("Нельзя удалить самого себя");
        }

        userRepository.delete(user);
    }

    @Transactional
    public void changePassword(Long userId, ChangePasswordRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("Пользователь не найден с id: " + userId));

        // Проверка текущего пароля
        if (!passwordEncoder.matches(request.getCurrentPassword(), user.getPassword())) {
            throw new IllegalArgumentException("Неверный текущий пароль");
        }

        // Установка нового пароля
        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        userRepository.save(user);
    }

    @Transactional
    public void changeUserPassword(Long userId, String newPassword) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("Пользователь не найден с id: " + userId));

        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }

    private UserResponse toResponse(User user) {
        return UserResponse.builder()
                .id(user.getId())
                .username(user.getUsername())
                .role(user.getRole())
                .fullName(user.getFullName())
                .email(user.getEmail())
                .active(user.getActive() != null ? user.getActive() : true)
                .build();
    }

    private User getCurrentUser() {
        // Получение текущего пользователя из контекста безопасности
        // Пока возвращаем null, так как в сервисе нет доступа к SecurityContext
        return null;
    }
}
