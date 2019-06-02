const program = require('commander');
const request = require('request');
const fs = require('fs');

function deploy(url, path, token, id, version, esoVersion) {

  console.log("deploy to %s", url);
  const formData = {
    id,
    version,
    updatefile: fs.createReadStream(path),
    // description: description,
    // changelog: changelog,
    compatible: esoVersion
  };

  return new Promise((resolve, reject) => {
    const options = { headers: { 'x-api-token': token }, url, formData };
    return request.post(options, (error, httpResponse, body) => {
      if (error) {
        reject(error)
      }
      
      if (httpResponse.statusCode - 200 > 100) {
        reject(httpResponse.statusMessage)
      } 

      console.log(`Successfully published to ESO.\n${body}`)
      resolve(body)
    })
  });
}

program
  .command('upload [url] [path] [token] [id] [version] [esoVersion]')
  .action(deploy);

program.parse(process.argv);