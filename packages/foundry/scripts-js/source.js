
const pathway = args[0];
const issueNum = args[1];

const url = `https://api.github.com/repos/${pathway}/issues/${issueNum}/comments`;
console.log(url);

const currentDate = new Date();
currentDate.setHours(0, 0, 0, 0);
const isoString = currentDate.toISOString();

const githubIssueRequest = Functions.makeHttpRequest({
    url: url,
    headers: {
        "Accept": "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28"
    },
    params: {
        since: isoString
    },
});

const githubIssueResponse = await githubIssueRequest;
if (githubIssueResponse.error) {
    console.error("err: %s" , githubIssueResponse.data);
    throw Error("Request failed");
}

// console.log(githubIssueResponse.data);

// get the number of ⚠️ in the body of the last comment which name is "Datacap Bot"
let warningCount = 0;
if (githubIssueResponse.data && githubIssueResponse.data.length > 0) {
  let lastDatacapBotComment;
  for (let i = githubIssueResponse.data.length - 1; i >= 0; i--) {
    if (githubIssueResponse.data[i].user.login === "datacap-bot[bot]") {
      lastDatacapBotComment = githubIssueResponse.data[i];
      break;
    }
  }

  if (lastDatacapBotComment) {
    warningCount = (lastDatacapBotComment.body.match(/⚠️/g) || []).length;
  }
}

return Functions.encodeUint256(warningCount);
