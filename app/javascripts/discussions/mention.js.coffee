$ ->
  $commentTextArea = $('@comment-text-area')
  displayTpl = "<li data-value='${atwho-at}${mention_name}'>
                  <img class='avatar' src='${avatar}'/>
                  ${name} (@${mention_name})
                </li>"
  data = [
    { name: 'Ильнур Газизуллин', mention_name: 'ilnur', avatar: 'https://iq300.s3.amazonaws.com/uploads/user_profile/photo/462/medium_1f7a19dd-6c9e-4e49-8e71-55bf61b744f3.jpg' },
    { name: 'Александр Мещеряков', mention_name: 'АлександрМещеряков', avatar: 'https://iq300.s3.amazonaws.com/uploads/user_profile/photo/1394/medium_fc37398f-9139-41cd-be1c-1d252d5f50f8.jpg' },
    { name: 'Шамиль Хамадеев', mention_name: 'hamadeev', avatar: 'https://iq300.s3.amazonaws.com/uploads/user_profile/photo/2/medium_e641ce02-e837-4d54-beaa-25724ff58b98.jpg' }
  ]
  data = data.concat(data, data, data)
  $commentTextArea
    .atwho
      at: "@"
      displayTpl: displayTpl
      insertTpl: "${atwho-at}${mention_name}"
      data: data
      limit: 200
