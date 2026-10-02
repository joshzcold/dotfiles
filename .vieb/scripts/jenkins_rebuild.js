{
  const url = location.href
  const parts = url.split("/")
  if (url.includes("console")) {
    location.href = `${parts.slice(0, -1).join("/")}/rebuild`
  } else if (url.includes("pipeline-overview")) {
    const base = url.replace(/(.*)pipeline-overview.*/, "$1").split("/")
    location.href = `${base.slice(0, -1).join("/")}/rebuild`
  } else if (url.includes("rebuild")) {
    document.getElementsByName("Submit")[0].click()
  } else {
    location.href = `${url.replace(/\/$/, "")}/lastBuild/console`
  }
}
