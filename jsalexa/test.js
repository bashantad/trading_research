const fs = require('fs')
const { Client } = require('pg');
process.setMaxListeners(2);

const client = new Client({
	host: 'localhost',
	database: 'alexa_research_development',
	port: 5432,
});

async function insertIntoDatabase(record, SiteName){
	const {recordDate, PageViews, Rank, Reach} = record;
	const {PerMillion, PerUser} = PageViews;
	const ReachPerMillion = Reach.PerMillion;
	const createdAt = new Date();
	const updatedAt = new Date();
	
	const query = {
	  text: 'INSERT INTO traffics(record_date, page_views_per_million, page_views_per_user, rank, reach_per_million, company_url, created_at, updated_at) VALUES($1, $2, $3, $4, $5, $6, $7, $8)',
	  values: [recordDate, PerMillion, PerUser, Rank, ReachPerMillion, SiteName, createdAt, updatedAt],
	};
	try {
		const response = await client.query(query);
		console.log('response =>', response);
	} catch(err) {
		console.log('error =>', err);
	}
	
}

const start = async function(a, b) {
	try {
		const content = fs.readFileSync('./response.json', 'utf8');
		const data = JSON.parse(content);
		const history = data["Awis"]["Results"]["Result"]["Alexa"]["TrafficHistory"];
		const records = history["HistoricalData"]["Data"];
		const SiteName = history["Site"];
		await client.connect();
		for(let i = 0; i < records.length; i++) {
			const record = records[i];
			record.recordDate = record.Date;
			await insertIntoDatabase(record, SiteName);
	  	}
	  	await client.end();
	} catch (err) {
		console.error(err);
	}
}

start();