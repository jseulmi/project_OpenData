package com.boot.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class GeminiRequest {

    private String model;
    private Content[] contents;

    // ★ 수정: systemInstruction 도 Content 타입이어야 함
    private Content systemInstruction;

    private GenerationConfig generationConfig;

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class Content {
        private Part[] parts;
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class Part {
        private String text;
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class GenerationConfig {
        private Integer maxOutputTokens;
        private Double temperature;
    }
}
