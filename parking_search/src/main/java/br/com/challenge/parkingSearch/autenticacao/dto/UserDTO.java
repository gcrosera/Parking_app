package br.com.challenge.parkingSearch.autenticacao.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class UserDTO {

    @NotEmpty(message = "Nome não pode ser vazio")
    private String name;

    @Email(message = "Email inválido")
    @NotEmpty(message = "Email não pode ser vazio")
    private String email;

    @Size(min = 6, message = "Senha deve ter pelo menos 6 caracteres")
    @NotEmpty(message = "Senha não pode ser vazia")
    private String password;

    @NotEmpty(message = "Telefone não pode ser vazio")
    private String phone;
}
