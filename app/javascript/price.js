const price = () => {
  const priceInput = document.getElementById("item-price");
  const addTaxPrice = document.getElementById("add-tax-price");
  const profit = document.getElementById("profit");

  if (priceInput) {
    priceInput.addEventListener("input", () => {
      const inputValue = Math.floor(parseFloat(priceInput.value)) || 0;  // 小数点以下を無効にする

      if (inputValue >= 300 && inputValue <= 9999999) {
        const tax = Math.floor(inputValue * 0.1);  // 10%の手数料を計算
        const profitValue = inputValue - tax;      // 利益を計算
        addTaxPrice.textContent = tax.toLocaleString();   // 手数料を表示
        profit.textContent = profitValue.toLocaleString(); // 利益を表示
      } else {
        addTaxPrice.textContent = ''; // 無効な値の場合は空にする
        profit.textContent = '';      // 無効な値の場合は空にする
      }
    });
  }
};

// turbo:load と turbo:render のイベントに対応
window.addEventListener("turbo:load", price);
window.addEventListener("turbo:render", price);
