$allowed_env = ['local', 'stage', 'prod']

$mock_data = {
	'client-info' 	=> {"clientId"=>"4xhSmt92RD", "name"=>"Вайзер Олександр", "webHookUrl"=>"", "permissions"=>"psf", "accounts"=>[{"id"=>"lu_DfA927YqdOUyQyiwIwA", "currencyCode"=>840, "cashbackType"=>"UAH", "balance"=>0, "creditLimit"=>0, "maskedPan"=>["537541******0394"], "type"=>"black", "iban"=>"UA983220010000026204304728629"}, {"id"=>"Wru4sMWBrWfsCGpwg_2OJg", "currencyCode"=>978, "cashbackType"=>"UAH", "balance"=>120000, "creditLimit"=>0, "maskedPan"=>["537541******8332"], "type"=>"black", "iban"=>"UA693220010000026203301620141"}, {"id"=>"vwM0597-8y5pyZX-RjmpZQ", "currencyCode"=>980, "cashbackType"=>"UAH", "balance"=>1549380, "creditLimit"=>0, "maskedPan"=>["537541******1260"], "type"=>"black", "iban"=>"UA173220010000026206300008932"}, {"id"=>"RXgPPTrGMLQu_iXuGRXJbg", "currencyCode"=>980, "cashbackType"=>"", "balance"=>0, "creditLimit"=>0, "maskedPan"=>[], "type"=>"fop", "iban"=>"UA623220010000026009300005217"}]},
	'statements'	=> [{"id"=>"fQ35XN5yrDI0wFys", "time"=>1612212722, "description"=>"Patreon", "mcc"=>5815, "amount"=>-14080, "operationAmount"=>-500, "currencyCode"=>840, "commissionRate"=>0, "cashbackAmount"=>0, "balance"=>1409232, "hold"=>false, "receiptId"=>"K737-HMXC-H45X-XA6K"}, {"id"=>"43zcG2xWtQ-OE3Or", "time"=>1612188144, "description"=>"Від: Антон К.", "mcc"=>4829, "amount"=>12400, "operationAmount"=>12400, "currencyCode"=>980, "commissionRate"=>0, "cashbackAmount"=>0, "balance"=>1423312, "hold"=>true}, {"id"=>"Gzl-xSPVTvsj-Lf5", "time"=>1612187087, "description"=>"Велика Кишеня", "mcc"=>5411, "amount"=>-12400, "operationAmount"=>-12400, "currencyCode"=>980, "commissionRate"=>0, "cashbackAmount"=>0, "balance"=>1410912, "hold"=>false, "receiptId"=>"HE3P-T762-EE2K-92EB"}, {"id"=>"ZEcXBmHXn6GzoqPN", "time"=>1612143372, "description"=>"Відсотки за сiчень", "mcc"=>4829, "amount"=>5010, "operationAmount"=>5010, "currencyCode"=>980, "commissionRate"=>0, "cashbackAmount"=>0, "balance"=>1423312, "hold"=>true}],
}

$mono_opts = {
	'site'      	=> 'https://api.monobank.ua',
	'token'			=> 'upFz6g7q4J-hkM8yiqs9Fuwxh2munEs5toRKqSFKuJmc',
	'client-info'	=> '/personal/client-info',
	'statements'	=> '/personal/statement/',
}

