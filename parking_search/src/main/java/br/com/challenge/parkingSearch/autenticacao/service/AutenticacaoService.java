package br.com.challenge.parkingSearch.autenticacao.service;

import br.com.challenge.parkingSearch.autenticacao.dto.LoginDTO;
import br.com.challenge.parkingSearch.autenticacao.dto.TokenDTO;
import br.com.challenge.parkingSearch.autenticacao.usuario.Usuario;
import br.com.challenge.parkingSearch.autenticacao.usuario.UsuarioDetailsImpl;
import br.com.challenge.parkingSearch.autenticacao.repository.UsuarioRepository;
import br.com.challenge.parkingSearch.usuario.model.Proprietario;
import br.com.challenge.parkingSearch.usuario.repository.ProprietarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.stereotype.Service;

@Service
public class AutenticacaoService {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private TokenService tokenService;

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private ProprietarioRepository proprietarioRepository;

    public TokenDTO autenticarUsuario(LoginDTO login) {
        var usernamePasswordAutentication = new UsernamePasswordAuthenticationToken(login.email(), login.senha());
        var authentication = authenticationManager.authenticate(usernamePasswordAutentication);
        var usuarioDetails = (UsuarioDetailsImpl) authentication.getPrincipal();

        // Busca o usuário no banco de dados
        Usuario usuario = usuarioRepository.findByEmail(login.email())
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        // Verifica se o usuário já tem um proprietário associado
        Proprietario proprietario = proprietarioRepository.findByUsuario(usuario)
                .orElseGet(() -> {
                    // Se não tiver, cria um novo proprietário e associa o usuário
                    Proprietario novoProprietario = new Proprietario();
                    novoProprietario.setUsuario(usuario);
                    novoProprietario.setId(usuario.getId());// Define o ID do Proprietário como o mesmo ID do Usuário
                    novoProprietario.setName(usuario.getNome());
                    novoProprietario.setEmail(usuario.getEmail());
                    novoProprietario.setPhone(usuario.getPhone());
                    return proprietarioRepository.save(novoProprietario);
                });

        // Gera o token
        String token = tokenService.gerarToken(usuarioDetails);

        // Retorna o TokenDTO com o token e o ID do usuário
        return new TokenDTO(token, usuario.getId());
    }
}
