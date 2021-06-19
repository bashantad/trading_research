//
// Copyright 2019 Amazon.com, Inc. and its affiliates. All Rights Reserved.
//
// Licensed under the MIT License. See the LICENSE accompanying this file
// for the specific language governing permissions and limitations under
// the License.
//

//node topsites.js country

const API_KEY = ""

const rp   = require('request-promise')
const util = require('util');
const readline = require('readline');
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
    await client.connect();
    for(let i = 0; i < records.length; i++) {
      const record = records[i];
      await insertIntoDatabase(record);
    }
    await client.end();
  } catch (err) {
    console.error(err);
  }
}

const apiHost = 'ats.api.alexa.com'

global.fetch = require("node-fetch");

function callATS(apikey, country) {
  var start = 3000;
  var uri = '/api?Action=TopSites&Count=100&Start=' + start + '&CountryCode=' + country + '&ResponseGroup=Country&Output=json';

  var options = {
    host: apiHost,
    path: uri,
    uri: 'https://' + apiHost + uri,
    json: true,
    headers: {'x-api-key': apikey},
        resolveWithFullResponse: true
  }

  rp(options)
  .then( (response)=> {
    extractAndProcessData(response.body);
  }).catch((error) => {
    console.log('failed:'+error)
  })
}

if (process.argv.length != 3) {
  console.log(`Usage: node ${process.argv[1]} APIKEY COUNTRY`);
  process.exit(0);
}

callATS(API_KEY, process.argv[2])