# Jornada do Usuário: Marta Oliveira — Cliente

Persona de referência: [Marta](./persona-cliente-marta.md).
Contextos de uso cobertos: **rotina doméstica**, **descoberta cautelosa** e **fidelização** (contextos 1, 2 e 3 da persona).

> Diferente das jornadas de Josué e Kátia, esta não partiu de um relato pronto do usuário — foi construída a partir do perfil, JTBD e traços de personalidade já registrados em [`persona-cliente-marta.md`](./persona-cliente-marta.md), que ainda não passou por refinamento direto com o usuário. Deve ser validada junto ao time antes de considerar fechada.

## Cenário
Marta precisa repor algo do dia a dia para a família (comida, produto de bairro) e vai ao app procurar perto de casa. Diferente de Josué, ela não compra por impulso: encontra um vendedor que nunca comprou antes e só decide pagar depois de conversar bastante e se sentir segura.

**Gatilho:** necessidade de reposição doméstica, combinada com desconfiança em pagar via PIX adiantado para alguém desconhecido.

## Jornada passo a passo

| # | Etapa | O que Marta faz | O que ela sente / pensa | Onde o app entra |
| --- | --- | --- | --- | --- |
| 1 | Necessidade doméstica | Percebe que precisa repor um item do dia a dia para a família | Rotina — quer resolver perto de casa, sem se deslocar longe | *(fora do app)* |
| 2 | Busca | Abre o app, faz login e rola o feed procurando vendedores próximos de casa | Cautela desde o início — não é o primeiro vendedor que vê que decide | **Login** · **Rolar/visualizar feed** |
| 3 | Descoberta de vendedor novo | Encontra a postagem de um vendedor que nunca comprou antes | Curiosidade com desconfiança — "não conheço esse aqui" | **Visualizar postagem** |
| 4 | Checagem de perfil | Abre o perfil completo do vendedor: foto, bio, telefone, nome e localização | Procura sinais de que o perfil é sério e completo — perfil incompleto já a faria desistir | **Visualizar perfil completo do vendedor** · **Localizar vendedor** (endereço/ponto de referência em texto) |
| 5 | Construção de confiança | Antes de decidir, manda várias mensagens no chat perguntando detalhes do produto (ingredientes, validade, forma de retirada) | Não compra por impulso — precisa "construir confiança conversando" | **Chat cliente↔vendedor** |
| 6 | Avaliação da resposta | Observa como o vendedor responde: rapidez, clareza, educação | Se a resposta for vaga ou demorada, a desconfiança aumenta | **Chat cliente↔vendedor** · **Notificação de chat** |
| 7 | Decisão | Sentindo-se segura com as respostas, decide fechar a compra | Confiança construída — agora sim aceita pagar adiantado | **Chat cliente↔vendedor** |
| 8 | Pagamento | Recebe o código PIX do vendedor pelo chat e paga | Ainda com um pé atrás, mas já decidiu confiar | **Gerar link/QR Code PIX** (entregue pelo chat) |
| 9 | Retirada | Vai buscar o produto no endereço/ponto de referência informado, perto de casa | Alívio ao confirmar que o produto era real | *(fora do app — retirada presencial)* |
| 10 | Fidelização | Gostando do produto, passa a seguir o vendedor no app | Quer reencontrá-lo com facilidade da próxima vez, sem procurar do zero | **Seguir vendedor** |
| 11 | Próxima compra | Na próxima necessidade, vai direto ao perfil do vendedor já conhecido em vez de rolar o feed | Já não precisa repetir todo o processo de desconfiança | **Pesquisar perfil/venda** · **Notificação de anúncio/nova postagem** |

## Funcionalidades do MVP acionadas nesta jornada
Referência: [`brainstorm-funcionalidades.md`](./brainstorm-funcionalidades.md).

| Nº no brainstorm | Funcionalidade | Etapa da jornada |
| --- | --- | --- |
| 19 | Login | 2 |
| 6 | Rolar/visualizar feed | 2 |
| 8 | Visualizar perfil completo do vendedor | 4 |
| 9 | Localizar vendedor (endereço estático / ponto de referência em texto) | 4 |
| 11 | Conversa entre vendedor e cliente (chat) | 5, 6, 7 |
| 12 | Notificação de chat | 6 |
| 13 | Gerar link/QR Code PIX | 8 |
| 16 | Seguir/deixar de seguir vendedor | 10 |
| 10 | Pesquisar perfil/venda | 11 |
| 14 | Notificação de anúncio/nova postagem | 11 |

## Dores da persona atendidas
- **"Desconfia de pagar via PIX antes de receber"** → mitigada nas etapas 5, 6 e 7 (chat como espaço de construir confiança antes de decidir).
- **"Quer reencontrar facilmente vendedores que já comprou"** → resolvida nas etapas 10 e 11 (seguir vendedor + pesquisar perfil direto).
- **"Precisa que o endereço seja bem claro em texto"** → resolvida na etapa 4 (perfil completo com localização em texto).
- **"Evita perfis incompletos"** → resolvida na etapa 4 (checagem do perfil antes de prosseguir).

## Pontos de atenção levantados pela jornada
- **Sinais de confiança insuficientes (etapas 4–7):** a persona pede explicitamente "histórico de conversa, tempo de perfil, referências" como sinais de confiança antes de pagar — mas a lista atual de funcionalidades ([`brainstorm-funcionalidades.md`](./brainstorm-funcionalidades.md)) não tem nenhum recurso de avaliação/reputação (ex.: nota do vendedor, número de vendas, tempo de conta). Hoje a única forma de Marta se sentir segura é o próprio chat manual — isso pode não ser suficiente para o perfil de cliente que a persona descreve. Vale decidir com o time se um indicador simples de reputação entra no escopo do MVP.
- **Sem confirmação de disponibilidade formal:** assim como na jornada do Josué, a decisão final de Marta depende inteiramente da resposta do vendedor no chat — se ele demorar para responder às perguntas, ela pode desistir antes mesmo de perguntar sobre o PIX.
- **Volume de mensagens antes de decidir (etapa 5):** diferente de Josué (uma mensagem rápida), Marta troca várias mensagens antes de fechar. Vale confirmar que o chat suporta bem esse uso mais longo (histórico visível, não só mensagens avulsas) — importante também para ela reconstruir a "história" com um vendedor já seguido.
- **Esta jornada ainda não foi validada com o usuário**, ao contrário das jornadas de Josué e Kátia — recomenda-se revisão em conjunto antes de tratá-la como definitiva para o MVP.
