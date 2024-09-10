package br.com.challenge.parkingSearch.usuario.DTO;

import lombok.AllArgsConstructor;
import lombok.Data;
@AllArgsConstructor
@Data
public class VagaDTO {
    private Long id;
    private String descricao;
    private double preco;
    private String cep;
    private String rua;
    private String numero;
    private String bairro;
    private String cidade;
    private String estado;
    private String imagemUrl;
    private Long proprietarioId;

    public VagaDTO() {

    }

    public void setIdProprietario(Long id) {
        this.proprietarioId = id;
    }

    public void setId(Long id) {
        this.id = id;
    }
}

