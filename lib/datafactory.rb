module DataFactory
	require 'net/http'
	require 'uri'
	require 'json'
	
	MOCK_DATA_FOR = ['local']
	DEFAULT_ENV = 'prod'
	API_URL = 'https://api.monobank.ua'
	TOKEN = ENV['MONO_TOKEN']
	TOKEN_ETH = ENV['ETH_TOKEN'] 
	ETH_ADDRESS = ENV["ETH_ADDRESS"] 
	ETH_URL = 'https://api.etherscan.io/api/'

	CLIENT_INFO_PATH = '/personal/client-info'
	STATEMENTS_PATH = '/personal/statement'
	CURRENCIES = {
		'840'			=> 'USD',
		'978'			=> 'EUR',
		'980'			=> 'UAH',
		'9999'			=> 'ETH',
	}
	
	MOCK_DATA = {
		'last_price' => {"ethbtc"=>"0.06809", "ethbtc_timestamp"=>"1643494559", "ethusd"=>"2603.9", "ethusd_timestamp"=>"1643494552"},
		'balance' => {"account"=>"0xA07fDc4A73a067078601a00C36dc6627FA0A80B8", "balance"=>"1881190803163104475"},
		'tx_list' => [{"blockNumber"=>"11877350", "timeStamp"=>"1613604825", "hash"=>"0x4e21ecb8b21c031b34fde7a33b88451fe896412883502411ef6a883f087c4a96", "nonce"=>"3069", "blockHash"=>"0x4593f9b7c799a674b1c2cfa67a39f5b83a6a6dcf95e9c3380225e3aaf9abf126", "transactionIndex"=>"143", "from"=>"0x77ab999d1e9f152156b4411e1f3e2a42dab8cd6d", "to"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "value"=>"1013977000000000000", "gas"=>"21000", "gasPrice"=>"146000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"11135499", "gasUsed"=>"21000", "confirmations"=>"2225946"},{"blockNumber"=>"11879338", "timeStamp"=>"1613631560", "hash"=>"0xca5a509c2ccec51ab010344ae7031a75fb65e8952692a4ee99cd16d0fa21b962", "nonce"=>"0", "blockHash"=>"0xffccc93befe0ea32cba343a38935d3c3aa58d17acd5b9776d0560ba0666c9ade", "transactionIndex"=>"169", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0xdac17f958d2ee523a2206206994597c13d831ec7", "value"=>"0", "gas"=>"50926", "gasPrice"=>"134000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x095ea7b30000000000000000000000007a250d5630b4cf539739df2c5dacb4c659f2488dffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff", "contractAddress"=>"", "cumulativeGasUsed"=>"10677171", "gasUsed"=>"46297", "confirmations"=>"2223958"},{"blockNumber"=>"11879365", "timeStamp"=>"1613631854", "hash"=>"0x061225f0eb08bf2b123beb646dd60911ddb1995cbb77de4ac651ae4705fa53d2", "nonce"=>"1", "blockHash"=>"0x7b505b8197c16af195554ffb40acdec8e07bcfbed4ae72c1d59fd204ec793535", "transactionIndex"=>"64", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0x7a250d5630b4cf539739df2c5dacb4c659f2488d", "value"=>"736897954410460079", "gas"=>"185689", "gasPrice"=>"126000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0xf305d719000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec70000000000000000000000000000000000000000000000000000000053724e000000000000000000000000000000000000000000000000000000000053077e400000000000000000000000000000000000000000000000000a2ce5c2e84e4462000000000000000000000000a07fdc4a73a067078601a00c36dc6627fa0a80b800000000000000000000000000000000000000000000000000000000602e1581", "contractAddress"=>"", "cumulativeGasUsed"=>"4663717", "gasUsed"=>"147825", "confirmations"=>"2223931"},{"blockNumber"=>"11887848", "timeStamp"=>"1613744366", "hash"=>"0xaaf9ba01b9537fbc858eabe5b415cb6205ff3bc4d802d316de26d5d05b043553", "nonce"=>"2", "blockHash"=>"0x4f726f1774e9a145a3b0d83a1c4af3ddfecd479b97bee80d6d3bb95f5b038e37", "transactionIndex"=>"100", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0x38d3d9abbdba8305ebb8b72996efe55bf785aed0", "value"=>"0", "gas"=>"94889", "gasPrice"=>"193000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x095ea7b30000000000000000000000007a250d5630b4cf539739df2c5dacb4c659f2488dffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff", "contractAddress"=>"", "cumulativeGasUsed"=>"5174480", "gasUsed"=>"84118", "confirmations"=>"2215448"},{"blockNumber"=>"11887870", "timeStamp"=>"1613744723", "hash"=>"0x5f62728b86fcdb8a3a00871db10a8f47fac7cdf926cc30473fe59bd07795b29c", "nonce"=>"3", "blockHash"=>"0x7c92fe3b1083d4b3c090c42b173820f4f5a3cc1ff30d0151b25b7aed580d98b8", "transactionIndex"=>"102", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0x7a250d5630b4cf539739df2c5dacb4c659f2488d", "value"=>"0", "gas"=>"204332", "gasPrice"=>"192000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x38ed1739000000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000039736f5d00000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000a07fdc4a73a067078601a00c36dc6627fa0a80b800000000000000000000000000000000000000000000000000000000602fcd9e000000000000000000000000000000000000000000000000000000000000000200000000000000000000000038d3d9abbdba8305ebb8b72996efe55bf785aed0000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48", "contractAddress"=>"", "cumulativeGasUsed"=>"6940006", "gasUsed"=>"164388", "confirmations"=>"2215426"},{"blockNumber"=>"11964483", "timeStamp"=>"1614763968", "hash"=>"0x26388ee23f6ab6a0696c946a3691fb01e7b8a55e83829bf9279c02634662b116", "nonce"=>"4951", "blockHash"=>"0x710621fa9bcf03e7b5f85b038af50d95fe29c68a557876a5a9be03ed4831d0fb", "transactionIndex"=>"243", "from"=>"0x77ab999d1e9f152156b4411e1f3e2a42dab8cd6d", "to"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "value"=>"320842030000000000", "gas"=>"21000", "gasPrice"=>"101000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"7529927", "gasUsed"=>"21000", "confirmations"=>"2138813"},{"blockNumber"=>"11964633", "timeStamp"=>"1614765941", "hash"=>"0x0407b069129ff4d7cc902807cdec11cd037c52e9c69cc7e0d83e366d619719d5", "nonce"=>"4", "blockHash"=>"0x932b7c45fea3073159c3ae62b66b8fcd1208d751b574c1d95bc2d1f2afa1e102", "transactionIndex"=>"54", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0x4592f3193481b073db2cd6f7333c346557be27af", "value"=>"52200000000000000", "gas"=>"21000", "gasPrice"=>"110000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"4041888", "gasUsed"=>"21000", "confirmations"=>"2138663"},{"blockNumber"=>"12042282", "timeStamp"=>"1615799344", "hash"=>"0xbf9032b774abfb1ae2c04ea2cada8080bae3c4efe66a2ff821b3b9de669d811b", "nonce"=>"5", "blockHash"=>"0x9cbb6aa066059fa28d044de614e83b6c48cca4e228c3959dda1589e2b6a327cf", "transactionIndex"=>"164", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48", "value"=>"0", "gas"=>"86790", "gasPrice"=>"144000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0xa9059cbb0000000000000000000000001b2e540a60077a70140a51682e059b5140b8148e00000000000000000000000000000000000000000000000000000000a8c15cea", "contractAddress"=>"", "cumulativeGasUsed"=>"9858827", "gasUsed"=>"42381", "confirmations"=>"2061014"},{"blockNumber"=>"12101360", "timeStamp"=>"1616586389", "hash"=>"0x7d8de08507740dd57fe27b1a23506a4ed2fa871d5c0965d3def4bf80f71a7958", "nonce"=>"6", "blockHash"=>"0x980048f0e0592a4833c4bc41d3c911ef9fb6f0cdbe5376ec9ce6ef4747d663db", "transactionIndex"=>"207", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0x4592f3193481b073db2cd6f7333c346557be27af", "value"=>"75800000000000000", "gas"=>"21000", "gasPrice"=>"126000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"12470349", "gasUsed"=>"21000", "confirmations"=>"2001936"},{"blockNumber"=>"12265220", "timeStamp"=>"1618764304", "hash"=>"0xaa2bf928f84f61458b31001682f1192ecd172866548e6913d885f7f769dd5b2e", "nonce"=>"7", "blockHash"=>"0xb5254c9a95c229be009195e7e2158343d97ced471046b06fcee27587b08f1a0d", "transactionIndex"=>"58", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48", "value"=>"0", "gas"=>"60496", "gasPrice"=>"128000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x095ea7b3000000000000000000000000881d40237659c251811cec9c364ef91dc08d300c0000000000000000000000000000000000000000004a817c7ffffffdabf41c00", "contractAddress"=>"", "cumulativeGasUsed"=>"11766214", "gasUsed"=>"60047", "confirmations"=>"1838076"},{"blockNumber"=>"12265221", "timeStamp"=>"1618764306", "hash"=>"0x1bfb3501e77ce01c90e2f1706bf7fb701e2a496d66363a60b6aceaf8765a24b4", "nonce"=>"8", "blockHash"=>"0xd1ad1ee5302bb09a47e6c3d3405600b53fd13e8d116e9187d01b0b95879e709d", "transactionIndex"=>"129", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0x881d40237659c251811cec9c364ef91dc08d300c", "value"=>"0", "gas"=>"281351", "gasPrice"=>"128000000000", "isError"=>"1", "txreceipt_status"=>"0", "input"=>"0x5f5755290000000000000000000000000000000000000000000000000000000000000080000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb480000000000000000000000000000000000000000000000000000000032a9f88000000000000000000000000000000000000000000000000000000000000000c0000000000000000000000000000000000000000000000000000000000000000d616972737761704c696768743200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018000000000000000000000000000000000000000000000000000000000607c615500000000000000000000000000000000000000000000000000000000607c620e000000000000000000000000a5d07e978398eb1715056d3ca5cb31035c02fdad000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec700000000000000000000000000000000000000000000000000000000325fa8ab000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb480000000000000000000000000000000000000000000000000000000032a9f880000000000000000000000000000000000000000000000000000000000000001bdf119f5cbd98f2b39c237c187a2f83bf954ab1d174b302fafaa6e659248d002364251aa07506f75c6fddf3cafb043f43c56fc8d6c70b5e68ed895f573a85a0da00000000000000000000000000000000000000000000000000000000000000000000000000000000000000007296333e1615721f4bd9df1a3070537484a50cf86c", "contractAddress"=>"", "cumulativeGasUsed"=>"7253368", "gasUsed"=>"112079", "confirmations"=>"1838075"},{"blockNumber"=>"12317316", "timeStamp"=>"1619458473", "hash"=>"0x737a448aafb4333094a3de5ac1ded544596cb0c8b1dfaca39d575f526ebd737f", "nonce"=>"10595", "blockHash"=>"0xe3653ec27cf53fd602a65ea1355ebddf7b2ef63ba13c3cb86581b616d15d8690", "transactionIndex"=>"195", "from"=>"0x77ab999d1e9f152156b4411e1f3e2a42dab8cd6d", "to"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "value"=>"73243900000000000", "gas"=>"21000", "gasPrice"=>"83000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"13351150", "gasUsed"=>"21000", "confirmations"=>"1785980"},{"blockNumber"=>"12321229", "timeStamp"=>"1619511216", "hash"=>"0xd528a2395a0726c9a9f3095966c1d422f6e811432f97473d57195664c1f826ab", "nonce"=>"9", "blockHash"=>"0x211873b0c5a970f44ff631ddeeba138e20a44a67d8bdd5acffd3bdc89e6b9efe", "transactionIndex"=>"304", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0x4592f3193481b073db2cd6f7333c346557be27af", "value"=>"62000000000000000", "gas"=>"21000", "gasPrice"=>"41000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"9966307", "gasUsed"=>"21000", "confirmations"=>"1782067"},{"blockNumber"=>"12331452", "timeStamp"=>"1619646659", "hash"=>"0x606290d20f2f651979dd96cf68bb8ae3c50f953b204c97068856b81f679fd3a2", "nonce"=>"10", "blockHash"=>"0x6922a19f277a71b2d69fc5ac770cce6fa8d0d73c760f1c94067c720b1883733a", "transactionIndex"=>"2", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "value"=>"0", "gas"=>"66836", "gasPrice"=>"112500000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"63000", "gasUsed"=>"21000", "confirmations"=>"1771844"},{"blockNumber"=>"12450122", "timeStamp"=>"1621230394", "hash"=>"0x4c8c215d4f472f05d78458cda3b590b6689a49e03c4f568d76f0854ce1a41658", "nonce"=>"11", "blockHash"=>"0xeccbf79348ade13948023b2c0c24d43fd398e24443d7a5a4292a31a8e5869115", "transactionIndex"=>"184", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0x7a250d5630b4cf539739df2c5dacb4c659f2488d", "value"=>"0", "gas"=>"317488", "gasPrice"=>"63000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0xded9382a000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7000000000000000000000000000000000000000000000000000014bbd175d50600000000000000000000000000000000000000000000000000000000761f3766000000000000000000000000000000000000000000000000086a48b0e5263929000000000000000000000000a07fdc4a73a067078601a00c36dc6627fa0a80b80000000000000000000000000000000000000000000000000000000060a20bfd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001c1b6185ce3cbf32c45006cb74e324742eb1f461c64f3bdae531ddfb4315e9b28632f5c085bedc6b17b5bda00ceb4bb23cae6b501431ce68db116624b5b90832b8", "contractAddress"=>"", "cumulativeGasUsed"=>"14495429", "gasUsed"=>"165108", "confirmations"=>"1653174"},{"blockNumber"=>"12450189", "timeStamp"=>"1621231469", "hash"=>"0xe096af71e80e8b312952cb4579775e9e12c5b6fd384e8d458523d2633c930fa5", "nonce"=>"12", "blockHash"=>"0xafa6b0d2d32be90250d14608ed80ce08b1846a8bf78e55aed2b84cabf0761f49", "transactionIndex"=>"110", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "value"=>"0", "gas"=>"58676", "gasPrice"=>"96000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"9593167", "gasUsed"=>"21000", "confirmations"=>"1653107"},{"blockNumber"=>"12450231", "timeStamp"=>"1621231962", "hash"=>"0x8df1c4e984bc2d51aee9ad300bd28323ad200e1af76cddffa3bb0740d1d95d51", "nonce"=>"13", "blockHash"=>"0x5e8b2878d436e3e8c42fee4618fe10bb738d8b7f759741a01864c5082a1d37d3", "transactionIndex"=>"54", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0xdac17f958d2ee523a2206206994597c13d831ec7", "value"=>"0", "gas"=>"58676", "gasPrice"=>"95000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x095ea7b3000000000000000000000000e592427a0aece92de3edee1f18e0157c05861564ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff", "contractAddress"=>"", "cumulativeGasUsed"=>"2770915", "gasUsed"=>"48897", "confirmations"=>"1653065"},{"blockNumber"=>"12450235", "timeStamp"=>"1621231999", "hash"=>"0xeca41489132e4598c270cae34f6a3c3722a54ac7c6233e4460f813ce379acca0", "nonce"=>"14", "blockHash"=>"0xdced3a3249119919d1012611d0e4732861cd5d4a04fc8ff537559be619c7b38b", "transactionIndex"=>"79", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0xe592427a0aece92de3edee1f18e0157c05861564", "value"=>"0", "gas"=>"156021", "gasPrice"=>"97000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x414bf389000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb4800000000000000000000000000000000000000000000000000000000000001f4000000000000000000000000a07fdc4a73a067078601a00c36dc6627fa0a80b80000000000000000000000000000000000000000000000000000000060a20e0a000000000000000000000000000000000000000000000000000000007c5d65d9000000000000000000000000000000000000000000000000000000007bbb19850000000000000000000000000000000000000000000000000000000000000000", "contractAddress"=>"", "cumulativeGasUsed"=>"4148902", "gasUsed"=>"111763", "confirmations"=>"1653061"},{"blockNumber"=>"12467123", "timeStamp"=>"1621458170", "hash"=>"0xd55563bacabdbc34d5d0f68d7d3610271d4c004f15674715045d198f2d756687", "nonce"=>"15", "blockHash"=>"0x46fd0643c20896fba2d6b77215752b0ee59b7b1ef34adb423f9d14e378393e37", "transactionIndex"=>"100", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0xe592427a0aece92de3edee1f18e0157c05861564", "value"=>"0", "gas"=>"276763", "gasPrice"=>"140000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0xac9650d8000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000016000000000000000000000000000000000000000000000000000000000000002a000000000000000000000000000000000000000000000000000000000000000c4f3995c67000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb480000000000000000000000000000000000000000000000000000000099724a570000000000000000000000000000000000000000000000000000000060a5857a000000000000000000000000000000000000000000000000000000000000001b100413ee81a584f199fc377d4ea3ac54054e489cbf0e40380e0ed248737fae2b1b6209c014b7ef3f8827697891b5e7e9b86c3f18a1a8f88ed242b39efc842b4a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000104db3e2198000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc20000000000000000000000000000000000000000000000000000000000000bb800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060a580ca0000000000000000000000000000000000000000000000000de0b6b3a76400000000000000000000000000000000000000000000000000000000000099724a57000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004449404b7c0000000000000000000000000000000000000000000000000de0b6b3a7640000000000000000000000000000a07fdc4a73a067078601a00c36dc6627fa0a80b800000000000000000000000000000000000000000000000000000000", "contractAddress"=>"", "cumulativeGasUsed"=>"8384757", "gasUsed"=>"198104", "confirmations"=>"1636173"},{"blockNumber"=>"12482763", "timeStamp"=>"1621668411", "hash"=>"0x84a8d71f84340c80e1f61318a39e840a83946e594ecfb9ceb627ddb979c51228", "nonce"=>"13210", "blockHash"=>"0xec4547c1335fc373532512b01bea686cec408253f0f3364bebdcbdd7e89c10ed", "transactionIndex"=>"345", "from"=>"0x77ab999d1e9f152156b4411e1f3e2a42dab8cd6d", "to"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "value"=>"85634830000000000", "gas"=>"21000", "gasPrice"=>"60000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"8864279", "gasUsed"=>"21000", "confirmations"=>"1620533"},{"blockNumber"=>"12541357", "timeStamp"=>"1622453292", "hash"=>"0x2a97835201957c2e90ef986acc2f52f1d94c30fe61cc269118c5b0362938eb28", "nonce"=>"16", "blockHash"=>"0xbb9be875497fba7d9800c8d35288c2c5004e6d8be7003b6a8d10034b9620b852", "transactionIndex"=>"177", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0x4592f3193481b073db2cd6f7333c346557be27af", "value"=>"62000000000000000", "gas"=>"21000", "gasPrice"=>"20000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"10042618", "gasUsed"=>"21000", "confirmations"=>"1561939"},{"blockNumber"=>"12704312", "timeStamp"=>"1624638626", "hash"=>"0x1b6d0757c060a84a3189d052f713208eecb992a4e7a95a3a2313868ab5489690", "nonce"=>"17", "blockHash"=>"0x0b367751692c2dd31e598d71302e50c63209aa28c7b3672a6159d9c92f14d147", "transactionIndex"=>"199", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0x4592f3193481b073db2cd6f7333c346557be27af", "value"=>"67800000000000000", "gas"=>"21000", "gasPrice"=>"49000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"12881252", "gasUsed"=>"21000", "confirmations"=>"1398984"},{"blockNumber"=>"12767491", "timeStamp"=>"1625488275", "hash"=>"0x75ca6a69e970df17dbbe99ecece7c960da151c16a372505f2c88d6e9654163be", "nonce"=>"16837", "blockHash"=>"0x80717bfa729b9bd1a37b3986c0afc72a0a198d267f3d32d09967857875bb62d8", "transactionIndex"=>"108", "from"=>"0x77ab999d1e9f152156b4411e1f3e2a42dab8cd6d", "to"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "value"=>"206802170000000000", "gas"=>"21000", "gasPrice"=>"11000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"8375644", "gasUsed"=>"21000", "confirmations"=>"1335805"},{"blockNumber"=>"12793010", "timeStamp"=>"1625831656", "hash"=>"0xec11e92b1948fd9747ec42a9b944eeae8054973af00d9a2c2ae4ed5454ab6155", "nonce"=>"18", "blockHash"=>"0x21d94e382f56ec14b364ffcb02498dbba776c46242bb1cf453951bfb637205ad", "transactionIndex"=>"95", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0x4592f3193481b073db2cd6f7333c346557be27af", "value"=>"39000000000000000", "gas"=>"21000", "gasPrice"=>"24000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"12680749", "gasUsed"=>"21000", "confirmations"=>"1310286"},{"blockNumber"=>"12902001", "timeStamp"=>"1627304987", "hash"=>"0xe0b78c56a1791d9a9b2fee25caa094563ac4661d8f724a5aabcc67d93986159d", "nonce"=>"19", "blockHash"=>"0xea29791afa28edb5ea84ef07467e3f11126dea9c7985909a6425c1c1446f7826", "transactionIndex"=>"130", "from"=>"0xa07fdc4a73a067078601a00c36dc6627fa0a80b8", "to"=>"0x4592f3193481b073db2cd6f7333c346557be27af", "value"=>"52000000000000000", "gas"=>"21000", "gasPrice"=>"47000000000", "isError"=>"0", "txreceipt_status"=>"1", "input"=>"0x", "contractAddress"=>"", "cumulativeGasUsed"=>"6533860", "gasUsed"=>"21000", "confirmations"=>"1201295"}],
		'client-info' 	=> {
			"clientId"=>"4xhSmt92RD", 
			"name"=>"Вайзер Олександр", 
			"webHookUrl"=>"", 
			"permissions"=>"psf", 
			"accounts"=>[
				{"id"=>"lu_DfA927YqdOUyQyiwIwA", "currencyCode"=>840, "cashbackType"=>"UAH", "balance"=>1200.0, "creditLimit"=>0, "maskedPan"=>["537541*0987"], "type"=>"BLACK", "iban"=>"UA983220010000026204304774520"}, 
				{"id"=>"Wru4sMWBrWfsCGpwg_2OJg", "currencyCode"=>978, "cashbackType"=>"UAH", "balance"=>12000, "creditLimit"=>0, "maskedPan"=>["537541*4567"], "type"=>"BLACK", "iban"=>"UA693220010000026203301609457"}, 
				{"id"=>"vwM0597-8y5pyZX-RjmpZQ", "currencyCode"=>980, "cashbackType"=>"UAH", "balance"=>1588, "creditLimit"=>0, "maskedPan"=>["537541*9875"], "type"=>"WHITE", "iban"=>"UA173220010000026206300063546"}, 
				{"id"=>"RXgPPTrGMLQu_iXuGRXJbg", "currencyCode"=>980, "cashbackType"=>"", "balance"=>12040, "creditLimit"=>0, "maskedPan"=>["FOP"], "type"=>"FOP", "iban"=>"UA173220010000026206300063546"}
			]
		},
		'statements'	=> [
			{"id"=>"fQ35XN5yrDI0wFys", "time"=>1612212722, "description"=>"Patreon", "mcc"=>5815, "amount"=>-14080, "operationAmount"=>-500, "currencyCode"=>840, "commissionRate"=>0, "cashbackAmount"=>0, "balance"=>1409232, "hold"=>false, "receiptId"=>"K737-HMXC-H45X-XA6K"}, 
			{"id"=>"43zcG2xWtQ-OE3Or", "time"=>1612188144, "description"=>"Від: Антон К.", "mcc"=>4829, "amount"=>12400, "operationAmount"=>12400, "currencyCode"=>980, "commissionRate"=>0, "cashbackAmount"=>0, "balance"=>1423312, "hold"=>true}, 
			{"id"=>"Gzl-xSPVTvsj-Lf5", "time"=>1612187087, "description"=>"Велика Кишеня", "mcc"=>5411, "amount"=>-12400, "operationAmount"=>-12400, "currencyCode"=>980, "commissionRate"=>0, "cashbackAmount"=>0, "balance"=>1410912, "hold"=>false, "receiptId"=>"HE3P-T762-EE2K-92EB"}, 
			{"id"=>"ZEcXBmHXn6GzoqPN", "time"=>1612143372, "description"=>"Відсотки за сiчень", "mcc"=>4829, "amount"=>5010, "operationAmount"=>5010, "currencyCode"=>980, "commissionRate"=>0, "cashbackAmount"=>0, "balance"=>1423312, "hold"=>true}
		],	
	}

	def DataFactory.send_request(url)
		https = Net::HTTP.new(url.host, url.port)
		https.use_ssl = true
		request = Net::HTTP::Get.new(url)
		request["X-Token"] = DataFactory::TOKEN
		response = https.request(request)
		if response.code == '200'
				client_info = JSON.parse(response.read_body)
				raise StandardError.new("empty response!") if client_info.empty?
		else 
				error = JSON.parse(response.read_body)
				raise StandardError.new("Respose from MONOBANK API: #{response.code} - #{error}.\nPlease try again later")
		end

		return client_info
	end

	def DataFactory.send_request_eth(url, params = [])
		par = "?"
		params.each do |variable|
			par = par + "#{variable[:name]}=#{variable[:value]}&"
		end
		uri = url + par
		uri = URI(uri + "apikey=#{DataFactory::TOKEN_ETH}")
		https = Net::HTTP.new(uri.host, uri.port)
		https.use_ssl = true
		request = Net::HTTP::Get.new(uri)
		response = https.request(request)
		if response.code == '200'
				client_info = JSON.parse(response.read_body)
				raise StandardError.new("empty response!") if client_info.empty?
		else 
				error = JSON.parse(response.read_body)
				raise StandardError.new("Respose from API: #{response.code} - #{error}.\nPlease try again later")
		end

		return client_info['result']
	end

	def DataFactory.get_eth_last_price
		params = [
			{name: 'module', value: 'stats'},
			{name: 'action', value: 'ethprice'}
		]
		return DataFactory.send_request_eth(DataFactory::ETH_URL, params)
	end

	def DataFactory.get_eth_balance
		params = [
			{name: 'module', value: 'account'},
			{name: 'action', value: 'balancemulti'},
			{name: 'tag', value: 'latest'},
			{name: 'address', value: DataFactory::ETH_ADDRESS}
		]
		bal = DataFactory.send_request_eth(DataFactory::ETH_URL, params)
		return bal[0]
	end

	def DataFactory.get_eth_txes
		params = [
			{name: 'module', value: 'account'},
			{name: 'action', value: 'txlist'},
			{name: 'tag', value: 'latest'},
			{name: 'address', value: DataFactory::ETH_ADDRESS},
			{name: 'startblock', value: 0},
			{name: 'endblock', value: 99999999},
			{name: 'page', value: 1},
			{name: 'offset', value: 25}
		]
		return DataFactory.send_request_eth(DataFactory::ETH_URL, params)
	end

	def DataFactory.get_eth_account(env = DEFAULT_ENV)
		if MOCK_DATA_FOR.include?(env)
			last_price = Marshal.load(Marshal.dump(DataFactory::MOCK_DATA['last_price']))
			balance = Marshal.load(Marshal.dump(DataFactory::MOCK_DATA['balance']))
		else
			last_price = DataFactory.get_eth_last_price
			balance = DataFactory.get_eth_balance
		end
		in_float = balance['balance'].to_i/1000000000000000000.to_f
		bal_eth = in_float.round(4)
		bal_usd = bal_eth * last_price['ethusd'].to_f
		bal_usd = bal_usd.round(0)
		account = {
			currencyCode: 'ETH',
			type: 'ETH',
			maskedPan: DataFactory::ETH_ADDRESS,
			balance: bal_usd,
			balance_eth: bal_eth,
			id: 'ETH'
		}
	end

	def DataFactory.get_statements (obj, env = DEFAULT_ENV, date_start = Time.now.to_i - 30*24*60*60, date_end = Time.now.to_i)
		if MOCK_DATA_FOR.include?(env)
			statements = Marshal.load(Marshal.dump(DataFactory::MOCK_DATA['statements']))
		else
			url = URI(DataFactory::API_URL + DataFactory::STATEMENTS_PATH + "/#{obj.selected_account}/#{date_start}/#{date_end}")
			statements = DataFactory.send_request(url)
		end
		parsed_statements = []
		statements.each do |stat| 
			stat = stat.transform_keys(&:to_sym)
			a = {
				time: Time.at(stat[:time]).strftime("%d.%m.%Y"), 
				amount: stat[:amount].to_f/100, 
				description: stat[:description],
				balance: stat[:balance].to_f/100,
			}
			parsed_statements.push(a)
		end
		obj.statements = parsed_statements
		return true
	end

	def DataFactory.get_client_info(obj,env = DEFAULT_ENV)
		if MOCK_DATA_FOR.include?(env) then
			client_info = Marshal.load(Marshal.dump(DataFactory::MOCK_DATA['client-info']))
		else
			url = URI.join(DataFactory::API_URL, DataFactory::CLIENT_INFO_PATH)
			client_info = DataFactory.send_request(url)
		end
		client_info = client_info.transform_keys(&:to_sym)
		accounts = client_info[:accounts]
		result_accounts = []
		accounts.each do |account|
			account = account.transform_keys(&:to_sym)
			account[:currencyCode] = CURRENCIES[account[:currencyCode].to_s]
			if account[:maskedPan].empty?
				account[:maskedPan] = account[:type].upcase
			else
				account[:maskedPan] = account[:maskedPan].first
			end
			account[:maskedPan] = account[:maskedPan].gsub('******', '*')
			account[:balance] = account[:balance].to_f/100
			account[:type] = account[:type].upcase
			result_accounts.push(account)
		end
		result_accounts.sort_by! { |k| k[:maskedPan]}
		result_accounts.push(DataFactory.get_eth_account(env))
		obj.accounts = result_accounts
		client_info.delete(:accounts)
		obj.client_info = client_info
		return true
	end
end
