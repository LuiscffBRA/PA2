# Brainstorm de Funcionalidades (MVP)

Lista de funcionalidades levantadas em brainstorm, conferidas contra `docs/linseption/visao-restricoes.md`. Itens marcados como *(adicionada)* não estavam na lista original do time e foram sugeridos para completar o conjunto até 20 — revisar e validar com o time antes de considerar fechado.

## Postagens
1. Criar postagem (produto/lanche)
2. Editar legenda da postagem
3. Deletar postagem
4. Comentar em postagens *(adicionada — explícito no "Faz" da visão do produto e faltava na lista original)*
5. Curtir postagem *(adicionada — suporte básico de engajamento social, dá base para notificação de anúncio)*
6. Rolar/visualizar feed

## Perfil
7. Editar perfil
8. Visualizar perfil completo do vendedor (foto, bio, telefone, nome) *(adicionada — explícito no "Faz" da visão do produto)*
9. Localizar vendedor (endereço estático/ponto de referência em texto ou link para Google Maps externo — **sem mapa interativo interno nem rastreamento GPS em tempo real**, conforme restrição do produto)
10. Pesquisar perfil/venda

## Chat
11. Conversa entre vendedor e cliente
12. Notificação de chat

## Pagamento
13. Gerar link/QR Code PIX

## Engajamento e Descoberta
14. Notificação de anúncio/nova postagem
15. Compartilhar link (perfil, produto, etc.)
16. Seguir/deixar de seguir vendedor *(adicionada — dá sentido a quem recebe notificação de anúncio)*
17. Sugestão de conteúdos *(adicionada — explícito no "Faz" da visão do produto)*

## Conta
18. Criar conta / cadastro
19. Login

## Moderação
20. Denunciar postagem/perfil *(adicionada — não está no documento de visão, mas é comum em apps com feed/chat público; marcar como sugestão a validar, não confirmada)*

---

## Observações de verificação contra `visao-restricoes.md`
- **Localizar vendedor**: cuidado no detalhamento da funcionalidade — o produto exibe apenas endereço estático, ponto de referência em texto, ou redireciona para o Google Maps externo. Não possui mapa interativo interno nem rastreamento GPS em tempo real (está explícito no "Não Faz" da visão do produto, para não confundir com apps estilo Uber/iFood/Zé Delivery).
- **Comentar em postagens**: estava faltando na lista original do brainstorm, mas é uma funcionalidade explícita no "Faz" da visão do produto ("Permite comentários nas fotos/postagens").
- Itens 5, 8, 9 (comentar já contado acima), 16, 17 e 20 foram adicionados para completar as 20 funcionalidades — recomenda-se validar com o time antes de considerar a lista fechada.
