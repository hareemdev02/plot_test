export default {
    mounted() {
        const TESTER = document.getElementById('plotly-chart');
        values = JSON.parse(TESTER.dataset.values);

        var layout = {
            bargap: 0.05,
            xaxis: { title: "Value" },
            yaxis: { title: "Count" }
        };

        Plotly.newPlot(TESTER, [{
            x: values,
            type: 'histogram'
        }], layout);
    },

    updated() {
        const TESTER = document.getElementById('plotly-chart');

        var layout = {
            bargap: 0.05,
            xaxis: { title: "Value" },
            yaxis: { title: "Count" }
        };

        Plotly.newPlot(TESTER, [{
            x: [1, 2, 3, 4, 5],
            type: 'histogram'
        }], layout);
    }
}