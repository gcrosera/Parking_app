package br.com.challenge.parkingSearch.autenticacao.service;

import br.com.challenge.parkingSearch.autenticacao.usuario.Usuario;
import br.com.challenge.parkingSearch.autenticacao.usuario.UsuarioDetailsImpl;
import br.com.challenge.parkingSearch.autenticacao.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class UsuarioDetailsServiceImpl implements UserDetailsService {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Usuario usuario = usuarioRepository.findByEmail(username).orElseThrow(()-> new RuntimeException("Usuário não encontrado"));
        return new UsuarioDetailsImpl(usuario);
    }
}
