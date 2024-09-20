package br.com.challenge.parkingSearch.autenticacao.dto;

public class TokenDTO {
    private String token;
    private Long userId;

    public TokenDTO(String token, Long userId) {
        this.token = token;
        this.userId = userId;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    // Getters e Setters
}
