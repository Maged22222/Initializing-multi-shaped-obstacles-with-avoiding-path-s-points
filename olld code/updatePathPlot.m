function updatePathPlot(hPath, path)
    % Update the path plot with new path coordinates
    set(hPath, 'XData', path(:, 1), 'YData', path(:, 2), 'ZData', path(:, 3));
    drawnow;  % Force the figure to update
end