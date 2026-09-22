# Jornada do Usuário: Katia — Vendedora

Persona de referência: [Katia](./persona-vendedora-katia.md).
Contextos de uso cobertos: **preparação matinal antes de sair de casa** e **durante a venda, na rua** (contextos 1 e 3 da persona).

## Cenário
Dia útil comum. Katia já monta sua barraca de tapioca no mesmo ponto de sempre, mas o movimento da manhã está fraco. Ela decide usar o app para atrair o público do almoço dos prédios da região antes que a janela de venda passe.

**Gatilho:** movimento fraco às 10h, com o horário de almoço se aproximando e o risco de não vender o suficiente no dia.

## Jornada passo a passo

| # | Etapa | O que Katia faz | O que ela sente / pensa | Onde o app entra |
| --- | --- | --- | --- | --- |
| 1 | Rotina da manhã | Acorda às 6h, prepara o café dos filhos, arruma as crianças e adianta a massa da tapioca | Corrida contra o tempo, prioridade nos filhos primeiro | *(fora do app)* |
| 2 | Montagem do ponto | Sai de casa às 8h, monta a barraca no ponto habitual e organiza os ingredientes | Rotina de trabalho, ainda sem sinal de como será o dia | *(fora do app)* |
| 3 | Percepção do problema | Por volta das 10h, nota que o movimento de pessoas na rua está muito fraco | Preocupação: "hoje pode não dar pra vender o suficiente" | *(fora do app)* |
| 4 | Decisão de agir | Decide tentar atrair o pessoal que vai almoçar logo mais | Determinação — provedora, não pode esperar passivamente | *(fora do app)* |
| 5 | Acesso ao app | Abre o aplicativo e faz login | Familiaridade — já trata o app como mais um canal de divulgação | **Login** |
| 6 | Produção do conteúdo | Frita uma ginga bem fresca e tira uma foto super apetitosa da tapioca montada | Capricho — sabe que a foto precisa vender o produto | *(fora do app — preparo e foto)* |
| 7 | Criação da postagem | Cria a postagem, edita a legenda com o preço do dia e detalha bem onde a barraca está localizada | Cuidado na descrição — quer transmitir confiança e clareza | **Criar postagem** · **Editar legenda da postagem** · **Localizar vendedor** (endereço/ponto de referência em texto) |
| 8 | Distribuição | O app exibe a postagem no feed das pessoas que trabalham nos prédios daquela região | Expectativa — vai ver se o alcance funciona | **Rolar/visualizar feed** (do lado do cliente) · **Sugestão de conteúdos** |
| 9 | Engajamento | Perto das 11h30, o celular notifica curtidas e mensagens de clientes perguntando se está pronta | Alívio e ânimo — o esforço está gerando retorno | **Curtir postagem** · **Notificação de chat** · **Chat vendedor↔cliente** |
| 10 | Negociação | Responde confirmando disponibilidade e vai adiantando os pedidos | Persuasiva e ágil — não pode travar no celular enquanto atende | **Chat vendedor↔cliente** |
| 11 | Pagamento | Gera o QR Code PIX para o pessoal já ir pagando | Praticidade — cliente paga sem precisar de dinheiro vivo, ela recebe garantido | **Gerar link/QR Code PIX** |
| 12 | Entrega e desfecho | Entrega as tapiocas quentinhas na hora do almoço, zera o estoque e garante o sustento da família | Satisfação e alívio — meta do dia cumprida | *(fora do app — entrega presencial)* |

## Funcionalidades do MVP acionadas nesta jornada
Referência: [`brainstorm-funcionalidades.md`](./brainstorm-funcionalidades.md).

| Nº no brainstorm | Funcionalidade | Etapa da jornada |
| --- | --- | --- |
| 19 | Login | 5 |
| 1 | Criar postagem | 7 |
| 2 | Editar legenda da postagem | 7 |
| 9 | Localizar vendedor (endereço/ponto de referência em texto) | 7 |
| 6 | Rolar/visualizar feed | 8 |
| 17 | Sugestão de conteúdos | 8 |
| 5 | Curtir postagem | 9 |
| 12 | Notificação de chat | 9 |
| 11 | Conversa entre vendedor e cliente (chat) | 9, 10 |
| 13 | Gerar link/QR Code PIX | 11 |

## Dores da persona atendidas
- **"Montar/atualizar o anúncio precisa ser rápido"** → resolvida na etapa 7 (criar postagem + editar legenda em um fluxo curto, feito ali mesmo na barraca).
- **"Precisa de mais alcance do que a divulgação própria já entrega"** → resolvida na etapa 8 (feed distribui a postagem para quem trabalha na região, sem que ela precise sair divulgando manualmente).
- **"Precisa responder o chat rápido enquanto está ocupada vendendo"** → resolvida nas etapas 9 e 10 (notificação avisa na hora, resposta simples confirma disponibilidade).
- **"Precisa de ferramenta simples, sem exigir conhecimento técnico"** → refletida no fluxo inteiro: da foto à postagem ao PIX, sem etapas complexas.

## Pontos de atenção levantados pela jornada
- **Distribuição por região (etapa 8):** a jornada pressupõe que o app já sabe direcionar a postagem para "pessoas que trabalham nos prédios daquela região". Isso é o mesmo ponto em aberto identificado na jornada do Josué — o MVP ainda não define como o feed segmenta por proximidade/região sem usar mapa interativo ou GPS em tempo real (restrição de [`visao-restricoes.md`](./visao-restricoes.md)). As duas jornadas juntas reforçam que essa regra de distribuição geográfica do feed é peça central do MVP, não um detalhe.
- **Volume de chat simultâneo (etapa 10):** Katia "vai adiantando os pedidos" enquanto atende múltiplos clientes ao mesmo tempo pelo chat. Vale avaliar se o MVP precisa de algo simples para ela não perder o fio de quem já confirmou/pagou (ex.: marcar conversa como "pedido confirmado"), já que ela está ocupada fisicamente na barraca e não pode gerenciar isso manualmente com calma.
- **Confirmação de pagamento (etapa 11):** o fluxo mostra Katia gerando o PIX e "adiantando os pedidos" antes de confirmar o recebimento — assumindo confiança do cliente. Como o app não processa o pagamento (só gera o link), não há como o app confirmar automaticamente que ela recebeu; ela decide sozinha quando entregar. Combina com o traço "Persuasiva/Provedora", mas é um risco operacional que fica fora do escopo do produto.
- **Estoque zerado (etapa 12):** não há, na lista de funcionalidades atual, nada que sinalize no feed que o produto acabou (ex.: marcar postagem como "esgotado"). Sem isso, um cliente pode ver a postagem depois das 11h30 e ir atrás de um produto que já não existe mais — a mesma frustração que a persona do Josué explicitamente quer evitar.
