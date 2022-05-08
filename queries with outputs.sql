-- task 1
-- this task is to pull overall sessions and orders volume, trended by quarter
-- this is requested by CEO on 2015-03-20
-- since the most recent quarter is incomplete, I will exclude it from the analysis

select
	year(ws.created_at) as yr,
    quarter(ws.created_at) as quar,
    count(distinct ws.website_session_id) as sessions,
    count(distinct order_id) as orders
from website_sessions ws
	left join orders o
		on ws.website_session_id = o.website_session_id
where ws.created_at < '2015-01-01'
group by 1, 2;


-- task 1 output
yr	quar	sessions	orders
2012	1	1879		60
2012	2	11433		347
2012	3	16892		684
2012	4	32266		1495
2013	1	19833		1273
2013	2	24745		1718
2013	3	27663		1840
2013	4	40540		2616
2014	1	46779		3069
2014	2	53129		3848
2014	3	57141		4035
2014	4	76373		5908

-- it looks like the overall trends of sessions and orders are increasing, despipte a drop down in the 4th quarter in 2012









-- task 2
-- this task is to showcase our efficiency improvement and to show quarterly for session-to-order conversion rate, revenue per order, and revenue per session
-- this task is request by CEO on 2013-03-20
-- since the most recent quarter is incomplete, I will exclude it from the analysis

select
	year(ws.created_at) as yr,
    quarter(ws.created_at) as quar,
    count(distinct order_id)/count(distinct ws.website_session_id) as conv_rt,
    sum(price_usd)/count(distinct order_id) as revenue_per_order,
    sum(price_usd)/count(distinct ws.website_session_id) as revenue_per_session
from website_sessions ws
	left join orders o
		on ws.website_session_id = o.website_session_id
where ws.created_at < '2015-01-01'
group by 1, 2;


-- task 2 output
yr	quar	conv_rt	revenue_per_order	revenue_per_session
2012	1	0.0319	49.990000		1.596275
2012	2	0.0304	49.990000		1.517233
2012	3	0.0405	49.990000		2.024222
2012	4	0.0463	49.990000		2.316217
2013	1	0.0642	52.142396		3.346809
2013	2	0.0694	51.538312		3.578211
2013	3	0.0665	51.734533		3.441114
2013	4	0.0645	54.715688		3.530741
2014	1	0.0656	62.160684		4.078136
2014	2	0.0724	64.374207		4.662462
2014	3	0.0706	64.494949		4.554298
2014	4	0.0774	63.793497		4.934885

-- it looks like revenue per order and revenue per session have been constantly increasing
-- the conversion rate experienced up and down during the 3 years









-- task 3
-- this task is to show we have grown specific channles and to pull quarterly view of orders from different channels
-- this task is requested by CEO on 2015-03-20
-- since the most recent quarter is incomplete, I will exclude it from the analysis

select
	year(ws.created_at) as yr,
    quarter(ws.created_at) as quar,
    count(distinct case when utm_source = 'gsearch' and utm_campaign = 'nonbrand' then order_id else null end) as gsearch_nonbrand,
    count(distinct case when utm_source = 'bsearch' and utm_campaign = 'nonbrand' then order_id else null end) as bsearch_nonbrand,
    count(distinct case when utm_source in('gsearch', 'bsearch') and utm_campaign = 'brand' then order_id else null end) as brand_search,
    count(distinct case when utm_source is null and utm_campaign is null and http_referer in ('https://www.gsearch.com', 'https://www.bsearch.com') then order_id else null end) as organic_search,
    count(distinct case when utm_source is null and utm_campaign is null and http_referer is null then order_id else null end) as direct_type_in
from website_sessions ws
	left join orders o
		on ws.website_session_id = o.website_session_id
where ws.created_at < '2015-01-01'
group by 1, 2;


-- task 3 output
yr	quar	gsearch_nonbrand	bsearch_nonbrand	brand_search	organic_search	direct_type_in
2012	1	60			0			0		0		0
2012	2	291			0			20		15		21
2012	3	482			82			48		40		32
2012	4	913			311			88		94		89
2013	1	766			183			108		125		91
2013	2	1114			237			114		134		119
2013	3	1132			245			153		167		143
2013	4	1657			291			248		223		197
2014	1	1667			344			354		338		311
2014	2	2208			427			410		436		367
2014	3	2259			434			432		445		402
2014	4	3248			683			615		605		532

-- the number of orders generated from all channels are all increasing
-- gsearch nonbrand generates the highest amount of orders
-- other four channels generate similar amount of orders









-- task 4
-- this task is to pull conversion rate for different channels, by quarter
-- this task is requested by CEO on 2015-03-20
-- since the most recent quarter is incomplete, I will exclude it from the analysis

select
	year(ws.created_at) as yr,
    quarter(ws.created_at) as quar,
    count(distinct case when utm_source = 'gsearch' and utm_campaign = 'nonbrand' then order_id else null end)
    	/count(distinct case when utm_source = 'gsearch' and utm_campaign = 'nonbrand' then ws.website_session_id else null end) as gsearch_nonbrand_conv_rt,
    count(distinct case when utm_source = 'bsearch' and utm_campaign = 'nonbrand' then order_id else null end)
    	/count(distinct case when utm_source = 'bsearch' and utm_campaign = 'nonbrand' then ws.website_session_id else null end)as bsearch_nonbrand_conv_rt,
    count(distinct case when utm_source in('gsearch', 'bsearch') and utm_campaign = 'brand' then order_id else null end)
    	/count(distinct case when utm_source in('gsearch', 'bsearch') and utm_campaign = 'brand' then ws.website_session_id else null end) as brand_search_conv_rt,
    count(distinct case when utm_source is null and utm_campaign is null and http_referer in ('https://www.gsearch.com', 'https://www.bsearch.com') then order_id else null end)
    	/count(distinct case when utm_source is null and utm_campaign is null and http_referer in ('https://www.gsearch.com', 'https://www.bsearch.com') then ws.website_session_id else null end) as organic_search_conv_rt,
    count(distinct case when utm_source is null and utm_campaign is null and http_referer is null then order_id else null end)
    	/count(distinct case when utm_source is null and utm_campaign is null and http_referer is null then ws.website_session_id else null end) as direct_type_in_conv_rt
from website_sessions ws
	left join orders o
		on ws.website_session_id = o.website_session_id
where ws.created_at < '2015-01-01'
group by 1, 2;


-- task 4 output
yr	quar	gsearch_nonbrand_conv_rt	bsearch_nonbrand_conv_rt	brand_search_conv_rt	organic_search_conv_rt	direct_type_in_conv_rt
2012	1	0.0324				NULL				0.0000			0.0000			0.0000
2012	2	0.0284				NULL				0.0526			0.0359			0.0536
2012	3	0.0384				0.0408				0.0602			0.0498			0.0443
2012	4	0.0436				0.0497				0.0531			0.0539			0.0537
2013	1	0.0612				0.0693				0.0703			0.0753			0.0614
2013	2	0.0685				0.0690				0.0679			0.0760			0.0735
2013	3	0.0639				0.0697				0.0703			0.0734			0.0719
2013	4	0.0629				0.0601				0.0801			0.0694			0.0647
2014	1	0.0693				0.0704				0.0839			0.0756			0.0765
2014	2	0.0702				0.0695				0.0804			0.0797			0.0738
2014	3	0.0703				0.0698				0.0756			0.0733			0.0702
2014	4	0.0782				0.0841				0.0812			0.0784			0.0748

-- the conversion rates are increasing for all channels
-- there was a major improvement in the 1st quarter of 2013, where conversion rates increased significantly









-- task 5
-- this task is to pull monthly trending for revenue and marginby product
-- this task is requested by CEO on 2015-03-20
-- since the most recent quarter is incomplete, I will exclude it from the analysis

SELECT 
    YEAR(wp.created_at) AS yr,
    MONTH(wp.created_at) AS mo,
	sum(case when pageview_url = '/the-original-mr-fuzzy' then price_usd else 0 end) as mrfuzzy_revenue,
    sum(case when pageview_url = '/the-original-mr-fuzzy' then price_usd - cogs_usd else 0 end) as mrfuzzy_margin,
    sum(case when pageview_url = '/the-forever-love-bear' then price_usd else 0 end) as lovebear_revenue,
    sum(case when pageview_url = '/the-forever-love-bear' then price_usd - cogs_usd else 0 end) as lovebear_margin,
    sum(case when pageview_url = '/the-birthday-sugar-panda' then price_usd else 0 end) as sugarpanda_revenue,
    sum(case when pageview_url = '/the-birthday-sugar-panda' then price_usd - cogs_usd else 0 end) as sugarpanda_margin,
    sum(case when pageview_url = '/the-hudson-river-mini-bear' then price_usd else 0 end) as minibear_revenue,
    sum(case when pageview_url = '/the-hudson-river-mini-bear' then price_usd - cogs_usd else 0 end) as minibear_margin
FROM website_pageviews wp
	LEFT JOIN orders o 
		ON wp.website_session_id = o.website_session_id
WHERE
    wp.created_at < '2015-01-01'
GROUP BY 1, 2;


-- task 5 output
yr	mo	mrfuzzy_revenue	mrfuzzy_margin	lovebear_revenue	lovebear_margin	sugarpanda_revenue	sugarpanda_margin	minibear_revenue	minibear_margin
2012	3	2999.40		1830.00		0.00			0.00		0.00			0.00			0.00			0.00
2012	4	4949.01		3019.50		0.00			0.00		0.00			0.00			0.00			0.00
2012	5	5398.92		3294.00		0.00			0.00		0.00			0.00			0.00			0.00
2012	6	6998.60		4270.00		0.00			0.00		0.00			0.00			0.00			0.00
2012	7	8448.31		5154.50		0.00			0.00		0.00			0.00			0.00			0.00
2012	8	11397.72	6954.00		0.00			0.00		0.00			0.00			0.00			0.00
2012	9	14347.13	8753.50		0.00			0.00		0.00			0.00			0.00			0.00
2012	10	18546.29	11315.50	0.00			0.00		0.00			0.00			0.00			0.00
2012	11	30893.82	18849.00	0.00			0.00		0.00			0.00			0.00			0.00
2012	12	25294.94	15433.00	0.00			0.00		0.00			0.00			0.00			0.00
2013	1	17196.56	10492.00	2819.53			1762.50		0.00			0.00			0.00			0.00
2013	2	16746.65	10217.50	9718.38			6075.00		0.00			0.00			0.00			0.00
2013	3	15996.80	9760.00		3899.35			2437.50		0.00			0.00			0.00			0.00
2013	4	22945.41	13999.50	5639.06			3525.00		0.00			0.00			0.00			0.00
2013	5	24445.11	14914.50	4919.18			3075.00		0.00			0.00			0.00			0.00
2013	6	25194.96	15372.00	5399.10			3375.00		0.00			0.00			0.00			0.00
2013	7	25394.92	15494.00	5699.05			3562.50		0.00			0.00			0.00			0.00
2013	8	25494.90	15555.00	5879.02			3675.00		0.00			0.00			0.00			0.00
2013	9	27094.59	16535.50	5629.06			3518.00		0.00			0.00			0.00			0.00
2013	10	31943.67	19516.50	6298.95			3937.50		0.00			0.00			0.00			0.00
2013	11	38192.43	23333.50	8438.59			5273.50		0.00			0.00			0.00			0.00
2013	12	44063.23	27044.50	8980.49			5615.50		5218.88	3		530.00			0.00			0.00
2014	1	41049.81	25313.50	8948.49			5604.50		6570.59			4448.50			0.00			0.00
2014	2	36666.20	22873.00	21997.99		13897.50	7428.31			5042.50			0.00			0.00
2014	3	48531.67	30273.50	10718.05		6772.50		8860.03			5971.50			0.00			0.00
2014	4	57631.72	35924.00	10666.08		6719.00		10427.63		7070.50			0.00			0.00
2014	5	66531.80	41571.00	13125.59		8291.50		9277.88			6305.00			0.00			0.00
2014	6	56839.92	35487.00	12611.72		7951.00		10599.61		7162.50			0.00			0.00
2014	7	61260.97	38227.50	12083.82		7618.00		10003.75		6758.50			0.00			0.00
2014	8	59611.27	37162.50	13065.58		8265.00		11979.24		8114.00			0.00			0.00
2014	9	67437.53	42136.50	13817.45		8740.50		10977.51		7432.50			0.00			0.00
2014	10	74440.01	46502.50	15319.22		9665.00		14146.75		9579.50			0.00			0.00
2014	11	91530.42	57121.00	20494.27		12939.50	16138.29		10924.50		0.00			0.00
2014	12	101328.51	63273.50	20042.32		12677.00	18355.81		12451.50		5096.38			3455.00

-- the revenue of all the products reaches the highest at the year end, and goes down in first months









-- task 6
-- this task is to pull monthly sessions to the product page with click through rate (CTR), along with a view of product to order conversion rate

SELECT 
    YEAR(wp.created_at) AS yr,
    month(wp.created_at) AS mo,
	count(distinct case when pageview_url = '/products' then ws.website_session_id else null end) as product_sessions,
    count(distinct case when pageview_url in ('/the-original-mr-fuzzy', '/the-forever-love-bear', '/the-birthday-sugar-panda', '/the-hudson-river-mini-bear') then ws.website_session_id else null end) as click_through_sessions,
    count(distinct case when pageview_url in ('/the-original-mr-fuzzy', '/the-forever-love-bear', '/the-birthday-sugar-panda', '/the-hudson-river-mini-bear') then ws.website_session_id else null end)
		/count(distinct case when pageview_url = '/products' then ws.website_session_id else null end) as CTR,
	count(distinct case when pageview_url = '/thank-you-for-your-order' then ws.website_session_id else null end) as order_sessions,
    count(distinct case when pageview_url = '/thank-you-for-your-order' then ws.website_session_id else null end)
		/count(distinct case when pageview_url = '/products' then ws.website_session_id else null end) as product_to_order_conv_rt
FROM website_sessions ws
	LEFT JOIN website_pageviews wp
		ON ws.website_session_id = wp.website_session_id
WHERE
    ws.created_at < '2015-01-01'
GROUP BY 1, 2;


-- task 6 output
yr	mo	product_sessions	click_through_sessions	CTR	order_sessions	product_to_order_conv_rt
2012	3	743			530			0.7133	60		0.0808
2012	4	1447			1029			0.7111	99		0.0684
2012	5	1584			1135			0.7165	108		0.0682
2012	6	1752			1247			0.7118	140		0.0799
2012	7	2018			1438			0.7126	169		0.0837
2012	8	3012			2198			0.7297	228		0.0757
2012	9	3126			2258			0.7223	287		0.0918
2012	10	4030			2948			0.7315	371		0.0921
2012	11	6743			4849			0.7191	618		0.0917
2012	12	5013			3620			0.7221	506		0.1009
2013	1	3380			2595			0.7678	390		0.1154
2013	2	3685			2803			0.7607	498		0.1351
2013	3	3371			2576			0.7642	385		0.1142
2013	4	4362			3356			0.7694	553		0.1268
2013	5	4684			3609			0.7705	571		0.1219
2013	6	4600			3536			0.7687	593		0.1289
2013	7	5020			3890			0.7749	604		0.1203
2013	8	5226			3951			0.7560	608		0.1163
2013	9	5399			4072			0.7542	629		0.1165
2013	10	6038			4564			0.7559	708		0.1173
2013	11	7886			5900			0.7482	861		0.1092
2013	12	8840			7026			0.7948	1047		0.1184
2014	1	7790			6386			0.8198	982		0.1261
2014	2	7960			6486			0.8148	1021		0.1283
2014	3	8110			6669			0.8223	1066		0.1314
2014	4	9744			7957			0.8166	1241		0.1274
2014	5	10261			8466			0.8251	1368		0.1333
2014	6	10011			8260			0.8251	1239		0.1238
2014	7	10837			8958			0.8266	1286		0.1187
2014	8	10768			8980			0.8340	1325		0.1230
2014	9	11128			9154			0.8226	1424		0.1280
2014	10	12335			10237			0.8299	1609		0.1304
2014	11	14476			12020			0.8303	1985		0.1371
2014	12	17240			14609			0.8474	2314		0.1342

-- whenever the company launched a product, the CTR and conversion rate increased









-- task 7
-- 4th product was available as a primary product on 2014-12-05, it was previously only as a cross-sell item
-- this task is to pull sales data since then, and show each product cross-sells fro mone another

SELECT 
   primary_product_id,
   count(distinct o.order_id) as orders,
   count(distinct case when is_primary_item = 0 and product_id = 1 then o.order_id else null end) as x_sell_p1,
   count(distinct case when is_primary_item = 0 and product_id = 2 then o.order_id else null end) as x_sell_p2,
   count(distinct case when is_primary_item = 0 and product_id = 3 then o.order_id else null end) as x_sell_p3,
   count(distinct case when is_primary_item = 0 and product_id = 4 then o.order_id else null end) as x_sell_p4
from orders o
	left join order_items oi 
		ON o.order_id = oi.order_id
WHERE o.created_at < '2015-03-20'
	and o.created_at >= '2014-12-05'
GROUP BY 1;


-- task 7 output
primary_product_id	orders	x_sell_p1	x_sell_p2	x_sell_p3	x_sell_p4
1			4467	0		238		553		933
2			1277	25		0		40		260
3			929	84		40		0		208
4			581	16		9		22		0

-- product 4 is alway sold as a cross-sell item with product 1
-- the orders of Product 4 as a cross-selling product even exceeded the orders as the main product