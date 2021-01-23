//
// Copyright 2019 Amazon.com, Inc. and its affiliates. All Rights Reserved.
//
// Licensed under the MIT License. See the LICENSE accompanying this file
// for the specific language governing permissions and limitations under
// the License.
//

// const DATE_RANGE = [
//  "2020-01-01", 
//  "2020-02-01", 
//  "2020-03-03", 
//  "2020-04-03", 
//  "2020-05-04", 
//  "2020-06-04", 
//  "2020-07-05", 
//  "2020-08-05", 
//  "2020-09-05", 
//  "2020-10-06", 
//  "2020-11-06", 
//  "2020-12-07", 
//  "2021-01-07"
// ]

 const DATE_RANGE = ["2019-12-01", "2019-10-31", "2019-09-30", "2019-08-30", "2019-07-30", "2019-06-29", "2019-05-29", "2019-04-28", "2019-03-28", "2019-02-25", "2019-01-25", "2018-12-25", "2018-11-24", "2018-10-24", "2018-09-23", "2018-08-23", "2018-07-23", "2018-06-22", "2018-05-22", "2018-04-21", "2018-03-21", "2018-02-18", "2018-01-18", "2017-12-18", "2017-11-17", "2017-10-17", "2017-09-16", "2017-08-16", "2017-07-16", "2017-06-15", "2017-05-15", "2017-04-14", "2017-03-14", "2017-02-11", "2017-01-11"]

const AWS = require('aws-sdk')
const rp   = require('request-promise')
const aws4 = require('aws4')
const util = require('util');
const readline = require('readline');

const amazonCognito = require('amazon-cognito-identity-js')

const CognitoUserPool = amazonCognito.CognitoUserPool
const AuthenticationDetails = amazonCognito.AuthenticationDetails
const CognitoUser = amazonCognito.CognitoUser


const cognitoUserPoolId = 'us-east-1_n8TiZp7tu'
const cognitoClientId = '6clvd0v40jggbaa5qid2h6hkqf'
const cognitoIdentityPoolId = 'us-east-1:bff024bb-06d0-4b04-9e5d-eb34ed07f884'
const cognitoRegion = 'us-east-1'
const awsRegion = 'us-east-1'
const apiHost = 'awis.api.alexa.com'
const credentialsFile = '.alexa.credentials'
const fs = require('fs');
const { Client } = require('pg');
process.setMaxListeners(2);

AWS.config.region = awsRegion;
global.fetch = require("node-fetch");

const poolData = {
  UserPoolId: cognitoUserPoolId,
  ClientId: cognitoClientId
}

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

const extractAndProcessData = async function(data) {
  try {    
    const history = data["Awis"]["Results"]["Result"]["Alexa"]["TrafficHistory"];
    const records = history["HistoricalData"]["Data"];
    const SiteName = history["Site"];
    for(let i = 0; i < records.length; i++) {
      const record = records[i];
      record.recordDate = record.Date;
      await insertIntoDatabase(record, SiteName);
    }    
  } catch (err) {
    console.error(err);
  }
}

const hiddenQuestion = query => new Promise((resolve,
  reject) => {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });
  const stdin = process.openStdin();
  process.stdin.on('data', char => {
    char = char + '';
    switch (char) {
      case '\n':
      case '\r':
      case '\u0004':
        stdin.pause();
        break;
      default:
        process.stdout.clearLine();
        readline.cursorTo(process.stdout, 0);
        process.stdout.write(query + Array(rl.line.length + 1).join('*'));
        break;
    }
  });
  rl.question(query, value => {
    rl.history = rl.history.slice(1);
    resolve(value);
  });
});

function getCognitoLoginKey() {
  return `cognito-idp.${cognitoRegion}.amazonaws.com/${cognitoUserPoolId}`
}

function getCredentials(email) {
  var awsCredentials = {}

  return new Promise(function(resolve, reject) {
    try {
      var contents = fs.readFileSync(credentialsFile, 'utf-8');
      awsCredentials = JSON.parse(contents);
    } catch (err) {
      awsCredentials = {'expireTime': new Date()};
    }
    var curTime = Date.now()
    if (new Date(awsCredentials.expireTime).getTime() > curTime)
      resolve(awsCredentials);
    else {
      const main = async () => {
          console.log('Password: ')
          const password = await hiddenQuestion('');
          login(email, password)
             .then( (credentials)=> resolve( credentials ))
             .catch( (e)=> reject(e))
        }
      main();
    }
  })
}


function login(email, password) {
    const authenticationDetails = new AuthenticationDetails({
      Username: email,
      Password: password
    })

    var cognitoUser = new CognitoUser({
      Username: email,
      Pool: new CognitoUserPool(poolData)
    })
    return new Promise((resolve, reject) => {
      cognitoUser.authenticateUser(authenticationDetails, {
        onSuccess: (result) => {
          AWS.config.credentials = new AWS.CognitoIdentityCredentials({
            IdentityPoolId: cognitoIdentityPoolId,
            Logins: {
              [getCognitoLoginKey()]: result.getIdToken().getJwtToken()
            }
          })

          AWS.config.credentials.refresh((error) => {
            if (error) {
              console.error(`Credentials refresh: ${error}`)
            } else {
              var awsCredentials = {
                    'accessKeyId': AWS.config.credentials.accessKeyId,
                    'secretAccessKey': AWS.config.credentials.secretAccessKey,
                    'sessionToken': AWS.config.credentials.sessionToken,
                    'expireTime': AWS.config.credentials.expireTime
              }

              fs.writeFileSync(credentialsFile, JSON.stringify(awsCredentials) , 'utf-8');
              resolve(awsCredentials);
            }
          })
        },
        onFailure: (result) => {
          console.error(`Result ${JSON.stringify(result)}`)
          reject(result);
        }
    })
  })
}


const callAwis = async (awsCredentials, apikey, site, startDate) => {
  var uri = '/api?Action=TrafficHistory&Output=json&ResponseGroup=History&Url=' + site + '&Start=' + startDate;

  var opts = {
  	host: apiHost,
  	path: uri,
  	uri: 'https://' + apiHost + uri,
  	json: true,
  	headers: {'x-api-key': apikey}
  }

  opts.region = awsRegion
  opts.service = 'execute-api'
  var signer  = new aws4.RequestSigner(opts, awsCredentials)

  signer.sign()

  rp(opts)
  .then( (response)=> {
    extractAndProcessData(response);
    //console.log(`${JSON.stringify(response, null, 2)}`);    
    console.log("======Finished rendering");    
  }).catch( (e)=> console.log('failed:'+e))
}

if (process.argv.length != 5) {
  console.log(`Usage: node ${process.argv[1]} USER APIKEY SITE`);
  process.exit(0);
}

const asyncProcessing = async (awsCredentials) => {
  await client.connect();
  for(let i = 0; i < DATE_RANGE.length; i++){
    let startDate = DATE_RANGE[i];   
    await callAwis(awsCredentials, process.argv[3], process.argv[4], startDate)  
  };
  //await client.end();
}

const processResult = (awsCredentials) => {
  asyncProcessing(awsCredentials);
}

  getCredentials(process.argv[2])
    .then(function(awsCredentials) {
      processResult(awsCredentials);      
    })
    .catch( (e)=> console.log(e))
