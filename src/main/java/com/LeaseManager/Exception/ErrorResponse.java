package com.LeaseManager.Exception;

import java.time.LocalDateTime;

public record ErrorResponse(String message, LocalDateTime time) {
}
