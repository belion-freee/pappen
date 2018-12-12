import 'chart.js';

const addChart = (ctx, data, backgroundColor, borderColor) => {
  ctx.canvas.height = 360;
  new Chart(ctx, {
      type: 'pie',
      data: {
          labels: JSON.parse(data.labels),
          datasets: [{
              label: '# of Votes',
              data: JSON.parse(data.numbers),
              backgroundColor: backgroundColor,
              borderColor: borderColor,
              borderWidth: 1,
              animation : true,
          }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        title: {
          display: true,
          text: data.title
      }
      }
  });
};

export default {
  Pie(id) {
    const element = document.getElementById(id);
    addChart(
      element.getContext('2d'),
      element.dataset,
      [
        'rgba(255, 99, 132, 0.2)',
        'rgba(54, 162, 235, 0.2)',
        'rgba(75, 192, 192, 0.2)',
        'rgba(255, 206, 86, 0.2)',
        'rgba(153, 102, 255, 0.2)',
        'rgba(255, 159, 64, 0.2)'
      ],
      [
        'rgba(255, 99, 132, 1)',
        'rgba(54, 162, 235, 1)',
        'rgba(75, 192, 192, 1)',
        'rgba(255, 206, 86, 1)',
        'rgba(153, 102, 255, 1)',
        'rgba(255, 159, 64, 1)'
      ]
    )
  },

  PieExpenditure(id) {
    const element = document.getElementById(id);
    addChart(
      element.getContext('2d'),
      element.dataset,
      [
        'rgba(255, 99, 132, 0.2)',
        'rgba(54, 162, 235, 0.2)',
        'rgba(75, 192, 192, 0.2)',
        'rgba(255, 206, 86, 0.2)',
        'rgba(153, 102, 255, 0.2)',
        'rgba(255, 159, 64, 0.2)',
        'rgba(20, 80, 20, 0.2)',
        'rgba(255, 32, 144, 0.2)',
        'rgba(0, 0, 100, 0.2)',
        'rgba(77, 77, 255, 0.2)',
        'rgba(0, 200, 0, 0.2)',
        'rgba(255, 150, 200, 0.2)',
        'rgba(0, 255, 255, 0.2)',
        'rgba(255, 0, 255, 0.2)',
        'rgba(0, 255, 0, 0.2)'
      ],
      [
        'rgba(255, 99, 132, 1)',
        'rgba(54, 162, 235, 1)',
        'rgba(75, 192, 192, 1)',
        'rgba(255, 206, 86, 1)',
        'rgba(153, 102, 255, 1)',
        'rgba(255, 159, 64, 1)',
        'rgba(20, 80, 20, 0.8)',
        'rgba(255, 32, 144, 0.8)',
        'rgba(0, 0, 100, 0.8)',
        'rgba(77, 77, 255, 0.8)',
        'rgba(0, 200, 0, 0.8)',
        'rgba(255, 150, 200, 0.8)',
        'rgba(0, 255, 255, 0.8)',
        'rgba(255, 0, 255, 0.8)',
        'rgba(0, 255, 0, 0.8)'
      ]
    )
  }
}
