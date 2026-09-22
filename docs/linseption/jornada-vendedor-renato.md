# Jornada do Usuário: Renato Silva — Vendedor

Persona de referência: [Renato](./persona-vendedor-renato.md).
Contextos de uso cobertos: **antes do evento**, **entre aula e trabalho** e **à noite, no evento** (contextos 1, 2 e 3 da persona).

> Diferente das jornadas de Josué e Kátia, esta não partiu de um relato pronto do usuário — foi construída a partir do perfil, JTBD e traços de personalidade já registrados em [`persona-vendedor-renato.md`](./persona-vendedor-renato.md), validada pelo usuário em 2026-09-08 como contraste direto com [Katia](./persona-vendedora-katia.md) (fixo x pontual, divulga fora do app x depende só do app). Deve ser validada junto ao time antes de considerar fechada.

## Cenário
Renato vai vender espetinho hoje à noite em um evento/feira pontual — um local diferente do último evento que fez. Entre a aula e o horário de trabalho, ele não tem tempo de divulgar manualmente como Katia faz; depende do próprio app para ser encontrado e confirmar pedidos antes de sair de casa, para não comprar insumo a mais ou a menos.

**Gatilho:** evento confirmado para a noite, com local e horário diferentes do anúncio anterior, e pouco tempo disponível entre estudo e trabalho para divulgar fora do app.

## Jornada passo a passo

| # | Etapa | O que Renato faz | O que ele sente / pensa | Onde o app entra |
| --- | --- | --- | --- | --- |
| 1 | Rotina do dia | Está entre aula e o compromisso de trabalho, sem tempo sobrando para divulgar em redes sociais | Objetivo — foco no que já precisa dar conta | *(fora do app)* |
| 2 | Confirmação do evento | Sabe que a feira/evento de hoje à noite é em um local diferente do último que vendeu | Planejador — precisa atualizar o anúncio antes de sair | *(fora do app)* |
| 3 | Atualização do anúncio | Antes de sair, abre o app, faz login e atualiza a postagem com o local e horário pontual de hoje, além do estoque disponível | Direto — quer um cadastro rápido, sem enrolação | **Login** · **Criar postagem** · **Editar legenda da postagem** · **Localizar vendedor** (local/horário do dia) |
| 4 | Publicação enxuta | Mantém a legenda focada no essencial: produto, local do dia, horário | Objetivo — anúncio enxuto, sem excesso de texto | **Editar legenda da postagem** |
| 5 | Distribuição | O app exibe a postagem no feed de quem está na região do evento | Confia que o app sozinho traz visibilidade — não tem tempo de divulgar por fora | **Rolar/visualizar feed** (do lado do cliente) · **Sugestão de conteúdos** |
| 6 | Primeiras respostas | Ao longo da tarde, o celular notifica mensagens de clientes perguntando sabor e quantidade disponível para o evento | Curioso e atento à tecnologia — acompanha o app com naturalidade | **Notificação de chat** · **Chat vendedor↔cliente** |
| 7 | Confirmação de pedidos | Responde confirmando os pedidos e anota as quantidades combinadas antecipadamente | Organizado — precisa fechar isso antes de sair de casa | **Chat vendedor↔cliente** |
| 8 | Cálculo de insumo | Com base nos pedidos confirmados pelo chat, calcula quanto insumo comprar/preparar, evitando sobra ou falta | Planejador — decisão prática apoiada na conversa do app | *(fora do app — decisão baseada nas confirmações do chat)* |
| 9 | Ida ao evento | Sai de casa no horário certo e monta a venda no local anunciado | Pronto para vender, sem desperdício calculado | *(fora do app)* |
| 10 | Atendimento no evento | Atende quem confirmou pedido pelo chat e também quem chegou vendo o anúncio no feed; gera o PIX para pagamento | Prático — resolve rápido entre um cliente e outro | **Chat vendedor↔cliente** · **Gerar link/QR Code PIX** |
| 11 | Desfecho | Fecha o estoque do dia sem sobra, encerrando o evento com o que planejou vender | Satisfação — meta cumprida, renda extra garantida | *(fora do app)* |

## Funcionalidades do MVP acionadas nesta jornada
Referência: [`brainstorm-funcionalidades.md`](./brainstorm-funcionalidades.md).

| Nº no brainstorm | Funcionalidade | Etapa da jornada |
| --- | --- | --- |
| 19 | Login | 3 |
| 1 | Criar postagem | 3 |
| 2 | Editar legenda da postagem | 3, 4 |
| 9 | Localizar vendedor (local/horário pontual do dia) | 3 |
| 6 | Rolar/visualizar feed | 5 |
| 17 | Sugestão de conteúdos | 5 |
| 12 | Notificação de chat | 6 |
| 11 | Conversa entre vendedor e cliente (chat) | 6, 7, 10 |
| 13 | Gerar link/QR Code PIX | 10 |

## Dores da persona atendidas
- **"Precisa deixar bem claro onde e quando vai estar naquele dia específico"** → resolvida na etapa 3 (atualização de local/horário pontual no anúncio antes de cada evento).
- **"Não tem tempo pra divulgar manualmente, depende do app sozinho"** → resolvida na etapa 5 (feed e sugestão de conteúdos fazem o alcance sem esforço extra dele).
- **"Precisa confirmar pedidos com antecedência para calcular insumo"** → resolvida nas etapas 6, 7 e 8 (chat antes do evento, cálculo de insumo baseado nas confirmações).
- **"Quer um cadastro rápido de atualizar a cada evento"** → resolvida na etapa 3 (fluxo enxuto de criar/editar postagem com o essencial).

## Pontos de atenção levantados pela jornada
- **Local variável por postagem, não por perfil:** a persona precisa mudar o local de venda a cada evento, mas [`visao-restricoes.md`](./visao-restricoes.md) descreve a localização como algo "exibido no perfil" do comerciante (endereço estático/ponto de referência). Isso funciona bem para Katia, que vende sempre no mesmo ponto, mas não para Renato — é preciso confirmar se, no MVP, o local pode ser definido **por postagem** (o evento do dia) e não só fixo no perfil, senão o anúncio dele ficaria desatualizado a cada evento.
- **Dependência total do alcance do feed (etapa 5):** como Renato não divulga fora do app (diferente de Katia), ele depende 100% de o feed/sugestão de conteúdos entregar visibilidade suficiente para quem está perto do evento daquele dia. Isso reforça o mesmo ponto em aberto já levantado nas jornadas de Josué e Kátia: falta definir a regra de distribuição geográfica do feed sem mapa interativo nem GPS.
- **Confirmação pelo chat sem garantia de comparecimento (etapa 7–8):** Renato calcula a quantidade de insumo com base em pedidos "confirmados" só por mensagem de chat, sem pagamento ou reserva formal antes do evento. Se um cliente confirmar e não aparecer, ele já comprou o insumo à toa — o app não oferece hoje nenhum mecanismo de reserva/sinal para reduzir esse risco.
- **Esta jornada ainda não foi validada com o usuário**, ao contrário das jornadas de Josué e Kátia — recomenda-se revisão em conjunto antes de tratá-la como definitiva para o MVP.
