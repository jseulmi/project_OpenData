package com.boot.controller;

import com.boot.service.GeminiService;
import lombok.RequiredArgsConstructor;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api")
public class GeminiController {
	private final GeminiService geminiService;
	
	@PostMapping(value="/gemini", produces="application/json; charset=UTF-8")
	public ResponseEntity<?> chat(@RequestBody Map<String, String> request) {
	    String message = request.get("message");
	    String reply = geminiService.askGemini(message);

	    return ResponseEntity.ok(
	        Map.of(
	            "contents", new Object[]{
	                Map.of(
	                    "parts", new Object[]{
	                        Map.of("text", reply)
	                    }
	                )
	            }
	        )
	    );
	}

}

