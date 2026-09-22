# Jornada do Usuário: Josué dos Santos — Cliente

Persona de referência: [Josué](./persona-cliente-josue.md).
Contexto de uso coberto: **no trabalho, durante o expediente/intervalo** (contexto 1 da persona).

## Cenário
Dia útil comum. Josué está no escritório, já almoçou a marmita fit trazida de casa e bate a vontade de um doce. Ele não pode furar a dieta nem se deslocar para longe antes de voltar ao trabalho.

**Gatilho:** vontade de doce logo após o almoço, com janela curta de tempo e restrição de dieta.

## Jornada passo a passo

| # | Etapa | O que Josué faz | O que ele sente / pensa | Onde o app entra |
| --- | --- | --- | --- | --- |
| 1 | Rotina da manhã | Acorda às 7h, toma café e vai para o trabalho levando a marmita fit feita pela esposa | Dia planejado, dieta sob controle | *(fora do app)* |
| 2 | Expediente | Trabalha intensamente como gestor de recursos das 8h às 12h, resolvendo problemas do escritório | Foco total, sem tempo para distração | *(fora do app)* |
| 3 | Almoço | Ao meio-dia come a marmita, mas logo em seguida bate a vontade forte de comer um doce | "Queria um doce, mas não posso furar a dieta" | *(fora do app)* |
| 4 | Restrição percebida | Lembra que não pode furar a dieta e que não tem tempo de ir longe comprar algo antes de voltar ao trabalho | Frustração + urgência: janela curta | *(fora do app)* |
| 5 | Busca | Pega o celular, abre o app e rola o feed procurando opções muito próximas ao prédio | Expectativa: "será que tem alguém perto?" | **Login** · **Rolar/visualizar feed** |
| 6 | Descoberta | Encontra a postagem de uma trufa fit artesanal com uma foto muito bem feita | Decisão por impulso — a foto vende | **Visualizar postagem** (foto + legenda do produto) |
| 7 | Avaliação | Abre o perfil completo do vendedor, confere a localização e vê que ele está na rua de trás | Alívio e confiança: "dá tempo, é perto" | **Visualizar perfil completo do vendedor** · **Localizar vendedor** (endereço/ponto de referência em texto) |
| 8 | Negociação | Manda uma mensagem rápida perguntando se ainda tem a trufa de morango pronta entrega | Quer confirmar disponibilidade antes de sair da mesa | **Chat cliente↔vendedor** · **Notificação de chat** |
| 9 | Confirmação | Recebe o "sim" do vendedor | Segurança: o produto existe e está reservado | **Chat cliente↔vendedor** |
| 10 | Pagamento | Copia o código PIX enviado pelo vendedor e faz o pagamento | Comodidade: não precisa de dinheiro vivo | **Gerar link/QR Code PIX** (entregue pelo chat) |
| 11 | Retirada | Desce na portaria e pega o doce fit | Rápido, sem sair do prédio | *(fora do app — retirada presencial)* |
| 12 | Desfecho | Mata a vontade sem sair da dieta e volta focado para o trabalho | Satisfação; tendência a repetir e virar cliente recorrente | *(fora do app)* |

## Funcionalidades do MVP acionadas nesta jornada
Referência: [`brainstorm-funcionalidades.md`](./brainstorm-funcionalidades.md).

| Nº no brainstorm | Funcionalidade | Etapa da jornada |
| --- | --- | --- |
| 19 | Login | 5 |
| 6 | Rolar/visualizar feed | 5 |
| 8 | Visualizar perfil completo do vendedor | 7 |
| 9 | Localizar vendedor (endereço estático / ponto de referência / link Google Maps) | 7 |
| 11 | Conversa entre vendedor e cliente (chat) | 8, 9 |
| 12 | Notificação de chat | 8, 9 |
| 13 | Gerar link/QR Code PIX | 10 |

## Dores da persona atendidas
- **"Não sabe quais vendedores estão por perto"** → resolvida nas etapas 5 e 7 (feed + localização no perfil).
- **"Já foi atrás de um produto e não achou disponível"** → resolvida na etapa 8/9 (confirma pelo chat *antes* de se deslocar).
- **"Prefere negociar rápido antes de se deslocar"** → resolvida na etapa 8.
- **"Quer pagar sem dinheiro vivo"** → resolvida na etapa 10 (PIX).

## Pontos de atenção levantados pela jornada
- **Proximidade no feed (etapa 5):** a jornada pressupõe que Josué consegue encontrar no feed opções *muito próximas ao prédio onde está*. Hoje a lista de funcionalidades não define como o feed prioriza proximidade, e o produto **não tem mapa interativo nem GPS em tempo real** (restrição em [`visao-restricoes.md`](./visao-restricoes.md)). É preciso decidir como isso funciona no MVP — por exemplo, ordenação/filtro do feed por bairro ou região declarada, sem rastreamento.
- **Confirmação de disponibilidade (etapa 8):** hoje depende 100% do vendedor responder o chat a tempo. Se a resposta demora, a janela de almoço de Josué fecha e a venda se perde. Vale avaliar um indicador simples de "pronta entrega / disponível" na própria postagem.
- **PIX pelo chat (etapa 10):** o fluxo desenhado é o vendedor enviar o código pelo chat e o cliente copiar. Confirmar se o MVP gera esse link direto na conversa ou se o vendedor precisa gerar em outra tela e colar.
- **Sem garantia de retirada (etapa 11):** o pagamento acontece antes da retirada presencial. Como o app não faz entrega nem intermediação, a confiança fica toda no vendedor — combina com o traço "Responsável" da persona e reforça a importância do perfil completo (etapa 7).
