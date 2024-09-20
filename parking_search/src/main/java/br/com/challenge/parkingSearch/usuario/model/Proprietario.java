package br.com.challenge.parkingSearch.usuario.model;

import br.com.challenge.parkingSearch.autenticacao.usuario.Usuario;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "tbl_proprietario")
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@EqualsAndHashCode(of = {"id"})
public class Proprietario {

    @Id
    private Long id; // O ID não deve ser gerado automaticamente

    @OneToOne
    @MapsId // Esta anotação indica que o ID do Proprietário será o mesmo do Usuário
    private Usuario usuario;

    private String name;

    @Column(unique = true)
    private String email;

    private String password;

    @Column(unique = true)
    private String phone;

    @OneToMany(mappedBy = "proprietario", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @JsonManagedReference
    private List<Vaga> vagas = new ArrayList<>();

}
