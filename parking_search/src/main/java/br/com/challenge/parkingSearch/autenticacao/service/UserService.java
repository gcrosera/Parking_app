package br.com.challenge.parkingSearch.autenticacao.service;

import br.com.challenge.parkingSearch.autenticacao.dto.UserDTO;
import br.com.challenge.parkingSearch.autenticacao.repository.UsuarioRepository;
import br.com.challenge.parkingSearch.autenticacao.usuario.Usuario;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UsuarioRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public void register(UserDTO userDTO) {
        // Verifica se o email já está cadastrado
        userRepository.findByEmail(userDTO.getEmail()).ifPresent(user -> {
            throw new RuntimeException("Email já cadastrado");
        });

        // Cria o novo usuário
        Usuario user = new Usuario();
        user.setNome(userDTO.getName());
        user.setEmail(userDTO.getEmail());
        user.setSenha(passwordEncoder.encode(userDTO.getPassword()));
        user.setPhone(userDTO.getPhone());

        // Salva o usuário no banco de dados
        userRepository.save(user);
    }

}
