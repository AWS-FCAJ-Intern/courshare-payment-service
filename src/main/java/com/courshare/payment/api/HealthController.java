package com.courshare.payment.api;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.Map;

@RestController
public class HealthController {
    @GetMapping("/")
    public Map<String, String> root() {
        return Map.of("service", "payment-service", "status", "UP");
    }
}
