package com.boot.service;

import com.boot.dto.GeminiRequest;
import com.boot.dto.GeminiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
@RequiredArgsConstructor
public class GeminiService {

    @Value("${gemini.api.key}")
    private String apiKey;

    private final RestTemplate restTemplate = new RestTemplate();

    public String askGemini(String prompt) {

        // ==== ★ systemInstruction + generationConfig 추가 ★ ====
    	GeminiRequest request = new GeminiRequest(
    	        "gemini-1.5-flash",
    	        new GeminiRequest.Content[]{
    	                new GeminiRequest.Content(
    	                        new GeminiRequest.Part[]{
    	                                new GeminiRequest.Part(prompt)
    	                        }
    	                )
    	        },
    	        // ★ systemInstruction (Content 형태!)
    	        new GeminiRequest.Content(
    	                new GeminiRequest.Part[]{
    	                        new GeminiRequest.Part(
    	                                "아래 질문에 대해 4~6문장 이내로 핵심만 간결하게, 쉽고 이해하기 쉽게 답변해줘. 너무 자세하거나 불필요하게 길게 설명하지 말고, 완성된 문장으로만 끝내. 필요하다면 이모지 하나쯤 써줘. 답이 길어질 것 같으면 정말 중요한 부분만 간추려 줘"
    	                        )
    	                }
    	        ),
    	        new GeminiRequest.GenerationConfig(150, 0.7)
    	);


        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<GeminiRequest> entity = new HttpEntity<>(request, headers);

        ResponseEntity<GeminiResponse> response =
                restTemplate.exchange(
                        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=" + apiKey,
                        HttpMethod.POST,
                        entity,
                        GeminiResponse.class
                );

        if (response.getBody() != null &&
                response.getBody().getCandidates() != null &&
                response.getBody().getCandidates().length > 0) {

            return response.getBody().getCandidates()[0].getContent().getParts()[0].getText();
        }

        return "응답 없음";
    }
}
