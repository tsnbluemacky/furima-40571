const pay = () => {
  // 公開鍵を取得してPAY.JPのオブジェクトを作成
  const publicKey = gon.public_key;
  const payjp = Payjp(publicKey);
  const elements = payjp.elements();
  
  // カード情報の入力フィールドを作成
  const numberElement = elements.create('cardNumber');
  const expiryElement = elements.create('cardExpiry');
  const cvcElement = elements.create('cardCvc');

  // 各フィールドを指定したDOM要素にマウント
  numberElement.mount('#number-form');
  expiryElement.mount('#expiry-form');
  cvcElement.mount('#cvc-form');

  // フォームの送信イベントをハンドル
  const form = document.getElementById('charge-form');
  const errorElement = document.getElementById('card-errors'); // エラーメッセージ表示用

  form.addEventListener("submit", (e) => {
    e.preventDefault();

    // トークンの作成
    payjp.createToken(numberElement).then((response) => {
      if (response.error) {
        // エラーハンドリング
        errorElement.textContent = response.error.message; // ユーザーにエラーメッセージを表示
        errorElement.style.color = 'red'; // 視覚的にエラーを強調
      } else {
        const token = response.id;
        const renderDom = document.getElementById("charge-form");
        const tokenObj = `<input value=${token} name='token' type="hidden">`;
        renderDom.insertAdjacentHTML("beforeend", tokenObj);

        // クレジットカード情報をクリア（セキュリティ強化のため）
        numberElement.clear();
        expiryElement.clear();
        cvcElement.clear();

        // フォームを送信
        form.submit();
      }
    });
  });
};

// ページのロード時にpay関数を呼び出し、turboのイベントに対応
window.addEventListener("turbo:load", pay);