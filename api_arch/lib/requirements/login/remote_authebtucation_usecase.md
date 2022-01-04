# Remote Authentication Usse Case 


## Caso de sucesso
1. Sistema valida os dados -> ok 
2. Sistema faz uma requisição para url da API de login -> ok
3. Sistema valida os dados recebidos da API
4. Sistema entrega os dados da conta do usuário

> ## Exeção - URL inválida
1.  Sistema retorna uma mensagem de erro insperado

> ## Exceção - Dados inválidos
1. Sistema retorna uma mensagem de erro inesperado -> ok

> ## Exceção - Resposta inválida 
1. Sistema retorna uma mensagem de erro inesperado 

> ## Ex  ceção - Falha no servidor 
1. Sistema retorna uma mensagem de erro inesperado 

> ## Exceção - Credenciais onválidas 
1. Sistema retorna uma mensagem de ero inesperado que as credenciais estão erradas 

<!--  -->


//TODO Testando casos de exceção do HttpClient