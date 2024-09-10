const pay = () => {

  // 公開鍵の取得と存在確認
  const publicKey = gon.public_key;
  if (!publicKey) {
    return;
  }

  // PAY.JPインスタンスの生成
  const payjp = Payjp(publicKey);
  const elements = payjp.elements();

  // カード情報入力フィールドの作成
  const numberElement = elements.create('cardNumber');
  const expiryElement = elements.create('cardExpiry');
  const cvcElement = elements.create('cardCvc');

  // カード入力フィールドをDOMにマウント
  numberElement.mount('#number-form');
  expiryElement.mount('#expiry-form');
  cvcElement.mount('#cvc-form');

  // エラーメッセージのリセット処理
  const resetErrors = (errorElement) => {
    if (errorElement) {
      errorElement.textContent = '';
      errorElement.style.color = '';
      errorElement.setAttribute('role', '');
    }
  };

  // エラーメッセージの表示処理
  const handleError = (message, errorElement) => {
    if (errorElement) {
      errorElement.textContent = message;
      errorElement.style.color = 'red';
      errorElement.setAttribute('role', 'alert');
    }
    console.error("エラー: " + message);
  };

  // トークン生成成功時の処理
  const handleTokenCreation = (token, form) => {
    const tokenInput = `<input value="${token}" name="token" type="hidden">`;
    form.insertAdjacentHTML("beforeend", tokenInput);

    // クレジットカード情報のクリア（セキュリティ強化のため）
    numberElement.clear();
    expiryElement.clear();
    cvcElement.clear();

    // フォームを送信
    form.submit();
  };

  // トークン生成のリクエスト
  const createToken = (payjp, errorElement) => {
    return payjp.createToken(numberElement).then((response) => {
      if (response.error) {
        handleError(response.error.message, errorElement);
        throw new Error(response.error.message);
      }
      return response.id;
    });
  };

  // フォーム送信時の処理
  const handleFormSubmit = (event, form) => {
    event.preventDefault();
    const errorElement = document.getElementById('card-errors');
    resetErrors(errorElement); // エラーをリセット

    createToken(payjp, errorElement)
      .then((token) => handleTokenCreation(token, form))
      .catch(() => handleError('トークンの作成に失敗しました。再度お試しください。', errorElement));
  };

  // フォーム送信イベントの設定
  const form = document.getElementById('charge-form');
  form.addEventListener('submit', (event) => handleFormSubmit(event, form));
};


window.addEventListener("turbo:load", pay);
window.addEventListener("turbo:render", pay);
