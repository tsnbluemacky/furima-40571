const pay = () => {
  // 公開鍵の取得と存在確認
  const publicKey = gon.public_key;
  if (!publicKey) {
    console.error("公開鍵が取得できませんでした。");
    alert("システムエラーが発生しました。後ほど再度お試しください。");
    return;
  }

  // PAY.JPインスタンスの生成
  const payjp = Payjp(publicKey);
  const elements = payjp.elements();

  // カード情報入力フィールドの作成
  const numberElement = elements.create('cardNumber');
  const expiryElement = elements.create('cardExpiry');
  const cvcElement = elements.create('cardCvc');

  // DOM要素にマウント
  numberElement.mount('#number-form');
  expiryElement.mount('#expiry-form');
  cvcElement.mount('#cvc-form');

  const form = document.getElementById('charge-form');
  const errorElement = document.getElementById('card-errors');

  // エラーメッセージのリセット処理
  const resetErrors = () => {
    errorElement.textContent = '';
    errorElement.style.color = '';
    errorElement.setAttribute('role', ''); // ARIA属性でエラーがなくなったことを知らせる
  };

  // エラーメッセージの表示処理
  const handleError = (message) => {
    errorElement.textContent = message;
    errorElement.style.color = 'red';
    errorElement.setAttribute('role', 'alert'); // スクリーンリーダー向けに設定
    console.error("エラー: " + message);
  };

  // トークン生成成功時の処理
  const handleTokenCreation = (token) => {
    const renderDom = document.getElementById("charge-form");
    const tokenObj = `<input value="${token}" name="token" type="hidden">`;
    renderDom.insertAdjacentHTML("beforeend", tokenObj);

    // クレジットカード情報のクリア（セキュリティ強化のため）
    numberElement.clear();
    expiryElement.clear();
    cvcElement.clear();

    // フォームを送信
    form.submit();
  };

  // フォーム送信時の処理
  form.addEventListener("submit", (e) => {
    e.preventDefault(); // ページリロードを防止
    resetErrors();  // エラーメッセージをリセット

    payjp.createToken(numberElement).then((response) => {
      if (response.error) {
        handleError(response.error.message);  // エラーハンドリング
      } else {
        handleTokenCreation(response.id);  // トークン生成成功時
      }
    }).catch((error) => {
      // 予期しないエラーの処理
      handleError('トークンの作成に失敗しました。再度お試しください。');
    });
  });
};

// Turboフレームワークに対応
window.addEventListener("turbo:load", pay);
window.addEventListener("turbo:render", pay);
