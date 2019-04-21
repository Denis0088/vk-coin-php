<?РНР
/**
 * VKCoinClient
 * @автор slmatthew (Матвей Вишневский)
 * @version 1.1
 */
класс  VKCoinClient {
	protected const API_HOST = 'https://coin-without-bugs.vkforms.ru/merchant';
	private  $apikey  = "";
	private $merchant_id = 0;
	/**
 * Конструктор
	 * 
 * @param int $merchant_id ID пользователя, для которого получен платёжный ключ
 * @param string $apikey Платёжный ключ
	 */
	публичная  функция  _ _ construct ( int  $merchant_id, string  $apikey) {
		if (version_compare ('7.0.0', phpversion ()) = = =  1) {
			die('Ваша версия не поддерживает эту версию библиотеки, используйте lib-5.6.php');
		}
		$this - > > merchant_id  =  $merchant_id;
		$this - > > apikey  =  $apikey;
	}
	/**
 * Функция request, используется для запросов к API
	 * 
 * @param string $метод
 * @param string $body
 * @return array | bool
	 */
	  запрос частной функции (string  $method, string  $body) {
		if (extension_loaded ('curl ')) {
			$ch = curl_init();
			curl_setopt_array($ch, [
				CURLOPT_URL  =>>  self:: API_HOST .'/ ' .$method.'/ ',
				CURLOPT_SSL_VERIFYPEER => false,
				CURLOPT_RETURNTRANSFER  = > >  true,
				CURLOPT_FOLLOWLOCATION => true,
				CURLOPT_POST  = > >  true,
				CURLOPT_POSTFIELDS  = > >  $body,
				CURLOPT_HTTPHEADER  = > > ['Content-Type: application / json ']
			]);
			$response  =  curl_exec ($ch);
			$err = curl_error($ch);
			curl_close($ch);
			if ($err) {
				возврат ['status'  = > >  false , 'error'  = > >  $err];
 } else {
				$response  =  json_decode ($response, true);
				вернуть ['status'  = > >  true, 'response'  = > >  isset ( $response ['response'])? $response ['response' ]: $response];
			}
		}
		возврат  false;
	}
	/**
 * Получение ссылки на оплату
	 * 
 * @param int $sum Сумма перевода
 * @param int $payload Полезная нагрузка. Если равно нулю, то будет сгенерировано рандомное число
 * @param bool $fixed_sum Фиксированная сумма, по умолчанию true
 * @param bool $use_hex_link Генерировать ссылку с hex-параметрами или нет
 * @ return string
	 */
	публичная  функция  generatePayLink ( int  $sum, int  $payload  =  0 , bool  $fixed_sum  =  true , bool  $use_hex_link  =  true) {
		$полезная нагрузка  =  $полезная нагрузка  = =  0 ? rand (- 2000000000, 2000000000): $ полезная нагрузка;
		if ($use_hex_link) {
			$merchant_id  =  dechex ( $this - > > merchant_id);
			$sum  =  dechex ($sum);
			$полезная нагрузка  =  dechex ($полезная нагрузка);
			$link  =  "vk.com/coin#m{ $merchant_id } _ { $sum } _ {$payload }" . ($fixed_sum ? "": "_1 ");
 } else {
			$merchant_id  =  $this - > > merchant_id;
			$link  =  "vk.com/coin#x{ $merchant_id } _ { $sum } _ {$payload }" . ($fixed_sum ? "": "_1 ");
		}
		возврат  $link;
	}
	/**
 * Получение списка транзакций
	 * 
 * @param int $tx_type _unk_: https://vk.com/@hs-marchant-api?anchor=poluchenie-spiska-tranzaktsy
 * @param int $last_tx Номер последней транзакции, всё описано в документации. По умолчанию не включён в запрос
	 */
	публичная  функция  getTransactions ( int  $tx_type  =  1 , int  $last_tx  = - 1) {
		$params = [];
		$params ['merchantId'] =  $this ->> merchant_id;
		$params ['key' ] =  $this - > > apikey;
		$params ['tx'] = [ $tx_type];
		if ($last_tx  != -1) {
			$params ['lastTx'] =  $last_tx;
		}
		возврат  $this - > > request ('tx ', json_encode ($params, JSON_UNESCAPED_UNICODE));
	}
	/**
 * Перевод
	 * 
 * @param int $to_id ID пользователя, которому будет отправлен перевод
 * @param int $amount Сумма перевода в тысячных долях (если укажите 15, то придёт 0,015 коина)
	 */
	публичная  функция  sendTransfer ( int  $to_id, int  $amount) {
		$params = [];
		$params ['merchantId'] =  $this ->> merchant_id;
		$params ['key' ] =  $this - > > apikey;
		$params ['toId'] =  $to_id;
		$params ['сумма'] =  $сумма;
		возврат  $this - > > request ('send ', json_encode ($params, JSON_UNESCAPED_UNICODE)); 
	}
	/**
 * Получение баланса
	 * 
 * @param array $user_ids ID пользователей
	 */
	публичная  функция  getBalance (array  $user_ids  = []) {
		if (empty ($user_ids)) {
			$user_ids  = [ $this - > > merchant_id];
		}
		$params = [];
		$params ['merchantId'] =  $this ->> merchant_id;
		$params ['key' ] =  $this - > > apikey;
		$params ['userIds'] =  $user_ids;
		возврат  $this - > > request ('score ', json_encode ($params, JSON_UNESCAPED_UNICODE));
	}
	/**
 * Изменение названия магазина
	 * 
 * @param string $name Название магазина
	 */
	имя изменения публичной  функции  (строка  $name) {
		$params = [];
		$params ['name '] =  $name;
		$params ['merchantId'] =  $this ->> merchant_id;
		$params ['key' ] =  $this - > > apikey;
		возврат  $this - > > request ('set ', json_encode ($params, JSON_UNESCAPED_UNICODE));
	}
	/**
 * Добавление Callback API сервера
	 * 
 * @param string $url _unk_
	 */
	публичная  функция  addWebhook (string  $url) {
		$params = [];
		$params ['callback'] =  $ url;
		$params ['merchantId'] =  $this ->> merchant_id;
		$params ['key' ] =  $this - > > apikey;
		возврат  $this - > > request ('set ', json_encode ($params, JSON_UNESCAPED_UNICODE));
	}
	/**
 * Удаление Callback API сервера
	 */
	публичная  функция  deleteWebhook() {
		$params = [];
		$params ['callback'] =  null;
		$params ['merchantId'] =  $this ->> merchant_id;
		$params ['key' ] =  $this - > > apikey;
		возврат  $this - > > request ('set ', json_encode ($params, JSON_UNESCAPED_UNICODE));
	}
	/**
 * Получение логов неудачных запросов
	 */
	публичная  функция  getWebhookLogs() {
		$params = [];
		$params ['status '] =  1;
		$params ['merchantId'] =  $this ->> merchant_id;
		$params ['key' ] =  $this - > > apikey;
		возврат  $this - > > request ('set ', json_encode ($params, JSON_UNESCAPED_UNICODE));
	}
	/**
 * Проверка подлинности ключа
	 * 
 * @param array $params Данные запроса, декодированные через json_decode(file_get_contents('php://input'), true)
	 */
	публичная  функция  isKeyValid (array  $params) {
		if (isset ($params ['id' ]) & &  isset ($params ['from_id']) & &  isset ($params ['amount' ]) & &  isset ($params ['полезная нагрузка']) & &  isset ($params [ 'key'])])) {
			$key  =  md5 (implode ( ' ;', [ $params ['id' ], $params ['from_id'], $params ['amount' ], $params ['полезная нагрузка'], $this - > > apikey]));
			возврат  $key  = = =  $params ['key '];
		}
		возврат  false;
	}
}
?>
