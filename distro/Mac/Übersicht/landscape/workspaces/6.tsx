import { run } from 'uebersicht'

const refreshFrequency = false

function selectSpace(ws) {
  run(`/usr/local/bin/yabai -m space --focus ${ws} && /usr/local/bin/landscape`)
}

function addSpace(ws) {
  run(
    `/usr/local/bin/yabai -m space --create && /usr/local/bin/yabai -m space --focus ${ws} && /usr/local/bin/landscape`,
  )
}

function deleteSpace() {
  run(`/usr/local/bin/yabai -m space --destroy && /usr/local/bin/landscape`)
}

const render = () => {
  return (
    <div class="screen">
      <link rel="stylesheet" type="text/css" href="/landscape/landscape.css" />
      <link
        rel="stylesheet"
        type="text/css"
        href="/landscape/.cache/current.css"
      />
      <div class="landscape">
        <ul>
          <li
            class="ls1"
            onClick={function () {
              selectSpace(1)
            }}
          ></li>
          <li
            class="ls2"
            onClick={function () {
              selectSpace(2)
            }}
          ></li>
          <li
            class="ls3"
            onClick={function () {
              selectSpace(3)
            }}
          ></li>
          <li
            class="ls4"
            onClick={function () {
              selectSpace(4)
            }}
          ></li>
          <li
            class="ls5"
            onClick={function () {
              selectSpace(5)
            }}
          ></li>
          <li
            class="ls6"
            onClick={function () {
              selectSpace(6)
            }}
          ></li>
          <li
            class="add"
            onClick={function () {
              addSpace(7)
            }}
            onContextMenu={function () {
              deleteSpace()
            }}
          >
            +
          </li>
        </ul>
      </div>
    </div>
  )
}

export { refreshFrequency, render }
