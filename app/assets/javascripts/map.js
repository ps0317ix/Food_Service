


// function initMap() {
//   jQuery(function($){
//     var map, map_center;
//     //初期のズーム レベル（指定がなければ 16）
//     var zoom = $("#zoom").text() ?  parseInt($("#zoom").text()): 16;
//     //マーカーのタイトル
//     var title = $('#venue').text();
//
//     //マップ生成のオプション
//     //center は Geolocation から取得して後で設定
//     var opts = {
//       zoom: zoom,
//       mapTypeId: "roadmap"  //初期マップ タイプ
//     };
//
//     //マップのインスタンスを生成
//     map = new google.maps.Map(document.getElementById("map_canvas"), opts);
//
//     //ジオコーディングのインスタンスの生成
//     var geocoder = new google.maps.Geocoder();
//
//     var address = $('#address').text();
//     // var my_reg = /〒\s?\d{3}(-|ー)\d{4}/;
//     //郵便番号を含めるとおかしくなる場合があったので、郵便番号は削除
//     // address = address.replace(my_reg, '');
//
//     //geocoder.geocode() にアドレスを渡して、コールバック関数を記述して処理
//     geocoder.geocode( { 'address': address}, function(results, status) {
//       if (status === 'OK' && results[0]) {
//         //results[0].geometry.location に緯度・経度のオブジェクトが入っている
//         map_center = results[0].geometry.location;
//         //地図の中心位置を設定
//         map.setCenter(map_center);
//         //マーカーのインスタンスを生成
//         var marker = new google.maps.Marker({
//           //マーカーを配置する Map オブジェクトを指定
//           map: map,
//           //マーカーの初期の場所を示す LatLng を指定
//           position: map_center,
//           //マーカーをアニメーションで表示
//           animation: google.maps.Animation.DROP,
//           title: title
//         });
//
//         //情報ウィンドウに表示するコンテンツを作成
//         //urlが指定してあればリンクつきのタイトルと住所を表示（URLがない場合もあるため）
//         var url = $("#url a").attr('href');
//         var content;
//         if (url) {
//           content = '<div id="map_content"><p><a href="' + url + '" target="_blank"> ' + title + '</a><br />' + address + '</p></div>';
//         }else {
//           //urlが指定してなければ、リンクなしのタイトルと住所を表示
//           content = '<div id="map_content"><p>' + title + '<br />' + address + '</p></div>';
//         }
//         //情報ウィンドウのインスタンスを生成
//         var infowindow = new google.maps.InfoWindow({
//           content: content,
//         });
//         //marker をクリックすると情報ウィンドウを表示(リスナーの登録）
//         google.maps.event.addListener(marker, 'click', function() {
//           //第2引数にマーカーを指定して紐付け
//           infowindow.open(map, marker);
//         });
//       } else {
//         alert("住所から位置の取得ができませんでした。: " + status);
//       }
//     });
//   });
// }
