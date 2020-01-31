let buildingObj


function closeUI(){
  CallEvent("DestroyPcUI")
}

function displayCam(idCam){
  CallEvent("DisplayCamView",idCam)
}

function changeScale(newScale){
  let wrapperScale = document.getElementById("wrapper").style.transform = "scale("+newScale+")"
}

function setBuildingName(){
  document.getElementById("buildingName").innerHTML = buildingObj.name
}

function setBuildingDatas(jsonBuilding){
  buildingObj = JSON.parse(JSON.stringify(jsonBuilding))
  setBuildingName()
  createCamera()
}

function createCamera(){
  let element = document.getElementById("camList");
  let id = 1
  if(buildingObj.cameras.length <= 5){
      element.style.overflowY = "hidden"
  }
  buildingObj.cameras.forEach(cam => {
    let div = document.createElement("div")
    div.setAttribute("id",id)
    div.setAttribute("class","cam")
    div.setAttribute("onclick","displayCam("+id+")")
    let img = document.createElement("img")
    img.setAttribute("src","http://asset/OriginRP/security/ui/img/cam_icon.png")
    img.setAttribute("class","camIcon")
    let title = document.createElement("h3")
    title.setAttribute("class","camName")
    let camName = document.createTextNode(cam.name)
    title.appendChild(camName)
    div.appendChild(img)
    div.appendChild(title)
    element.appendChild(div);
    id++
  });
}