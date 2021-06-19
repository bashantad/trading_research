const fs = require('fs')
const { Client } = require('pg');
process.setMaxListeners(2);
const client = new Client({
  host: 'localhost',
  database: 'alexa_research_development',
  port: 5432,
});


async function insertIntoDatabase(record){
	const { DataUrl, Country, Global } = record;
	const {Reach, PageViews } = Country;
	const ReachPerMillion = Reach.PerMillion;
	const {PerMillion, PerUser} = PageViews;
	const GlobalRank = Global.Rank;
	const CountryRank = Country.Rank;
	const createdAt = new Date();
	const updatedAt = new Date();
	const values = [DataUrl, GlobalRank, PerMillion, PerUser, CountryRank, ReachPerMillion, createdAt, updatedAt];
  
  const query = {
    text: 'INSERT INTO top_sites(company_url, global_rank, page_views_per_million, page_views_per_user, country_rank, reach_per_million, created_at, updated_at) VALUES($1, $2, $3, $4, $5, $6, $7, $8)',
    values: values,
  };
  try {
    const response = await client.query(query);
    console.log('inserted =>', response.rowCount + ' record');
  } catch(err) {
    console.log('error =>', err);
  }
}

const extractAndProcessData = async function(data) {
  try {    
    const history = data["Ats"]["Results"]["Result"]["Alexa"]["TopSites"];
    const records = history["Country"]["Sites"]["Site"];
    for(let i = 0; i < records.length; i++) {
      const record = records[i];
      await insertIntoDatabase(record);
    }    
  } catch (err) {
    console.error(err);
  }
}


const start = async function(a, b) {
	try {
		const content = fs.readFileSync('./response_top_sites.json', 'utf8');
		const data = JSON.parse(content);		
		await client.connect();
		await extractAndProcessData(data);
	  await client.end();
	} catch (err) {
		console.error(err);
	}
}

start();
