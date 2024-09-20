package br.com.challenge.parkingSearch.autenticacao.controller;

import br.com.challenge.parkingSearch.autenticacao.dto.LoginDTO;
import br.com.challenge.parkingSearch.autenticacao.dto.TokenDTO;
import br.com.challenge.parkingSearch.autenticacao.dto.UserDTO;
import br.com.challenge.parkingSearch.autenticacao.service.AutenticacaoService;
import br.com.challenge.parkingSearch.autenticacao.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("users")
public class AutenticacaoController {

    @Autowired
    private AutenticacaoService autenticacaoService;

    @Autowired
    private UserService userService;  // Injeção do UserService

    @PostMapping("/login")
    public ResponseEntity<TokenDTO> autenticarUsuario(@RequestBody LoginDTO login) {
        var token = autenticacaoService.autenticarUsuario(login);
        return new ResponseEntity<>(token, HttpStatus.OK);
    }

    // Novo método para cadastro
    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody UserDTO userDTO) {
        try {
            userService.register(userDTO);  // Usando o UserService injetado pelo Spring
            return ResponseEntity.status(HttpStatus.CREATED).body("Usuário cadastrado com sucesso");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Erro ao cadastrar usuário: " + e.getMessage());
        }
    }

}
