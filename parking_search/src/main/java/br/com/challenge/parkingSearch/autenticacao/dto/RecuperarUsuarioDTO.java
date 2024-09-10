package br.com.challenge.parkingSearch.autenticacao.dto;

import br.com.challenge.parkingSearch.autenticacao.usuario.Role;

import java.util.List;

public record RecuperarUsuarioDTO(

        Long id,
        String email,
        List<Role> roles
) {
}
