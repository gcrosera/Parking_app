package br.com.challenge.parkingSearch.usuario.model;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.*;

import java.util.List;

@Entity
@Table(name = "tbl_vaga")
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@EqualsAndHashCode(of = {"id"})
public class Vaga {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String descricao;
    private double preco;
    private String imagemUrl;

    @Size(min = 8, max = 8, message = "O CEP deve ter exatamente 8 dígitos")
    @Pattern(regexp = "\\d{8}", message = "O CEP deve conter apenas números")
    private String cep;
    private String rua;
    private String numero;
    private String bairro;
    private String cidade;
    private String estado;

    @ManyToOne
    @JoinColumn(name = "proprietario_id", nullable = false)
    @JsonBackReference
    private Proprietario proprietario;

    public void setImagemUrls(List<String> urls) {
        this.imagemUrl = String.join(",", urls);
    }

}
