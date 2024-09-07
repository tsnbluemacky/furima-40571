const pay = () => {
  console.log("ok")
  console.log(gon.public_key);  // 公開鍵が正しく渡されているかを確認
  console.log(Payjp); // Payjpオブジェクトが正しく読み込まれたか確認

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
  const formElements = {
    numberElement: elements.create('cardNumber'),
    expiryElement: elements.create('cardExpiry'),
    cvcElement: elements.create('cardCvc')
  };

  // カード入力フィールドをDOMにマウント
  const initializePaymentForm = (formElements) => {
    const { numberElement, expiryElement, cvcElement } = formElements;
    numberElement.mount('#number-form');
    expiryElement.mount('#expiry-form');
    cvcElement.mount('#cvc-form');
  };

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
  const handleTokenCreation = (token, formElements, form) => {
    const { numberElement, expiryElement, cvcElement } = formElements;

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
  const createToken = (payjp, numberElement, errorElement) => {
    return payjp.createToken(numberElement).then((response) => {
      if (response.error) {
        handleError(response.error.message, errorElement);
        throw new Error(response.error.message); // エラーをスローしてキャッチする
      }
      return response.id;
    });
  };

  // フォーム送信時の処理
  const handleFormSubmit = (event, payjp, formElements, form) => {
    event.preventDefault(); // ページリロードを防止
    const errorElement = document.getElementById('card-errors');
    resetErrors(errorElement); // エラーをリセット

    createToken(payjp, formElements.numberElement, errorElement)
      .then(token => handleTokenCreation(token, formElements, form))
      .catch(() => handleError('トークンの作成に失敗しました。再度お試しください。', errorElement));
  };

  // 支払いフォームの初期化
  initializePaymentForm(formElements);

  const form = document.getElementById('charge-form');
  form.addEventListener('submit', (event) => handleFormSubmit(event, payjp, formElements, form));
};

// Turboフレームワークに対応
window.addEventListener("turbo:load", pay);
window.addEventListener("turbo:render", pay);
